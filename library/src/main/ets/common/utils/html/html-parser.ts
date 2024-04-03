/**
 * htmlParser改造自: https://github.com/blowsie/Pure-JavaScript-HTML5-Parser
 */
import type {
  Attribute,
  CustomHandler,
  HtmlParserResult,
  ImageProp,
  NodeInfo,
  SimpleNode
} from '../../types/htmlParser';
import { excludeExtendsParentArtUIStyle, parseStyle, parseToArtUI, setHtmlAttributes } from '../css/index';
import { strDiscode, urlToHttpUrl } from './discode';
import { ImageFit } from '../../types/artUIEnum';
import {
  attr,
  block,
  closeSelf,
  empty,
  endTag,
  fillAttrs,
  filterAttrs,
  inline,
  removeDOCTYPE,
  replaceWebpPic,
  special,
  startTag,
  trimHtml
} from './index';
import Node from './node';
import Stack from './stack';

// 默认自定义标签匹配处理方法
const defaultCustomHandler: CustomHandler = {
  start() {
    return (node: NodeInfo) => {
      node.attr.class = null;
      node.attr.style = null;
    };
  },
  end: null,
  chars: null
};
// 默认自定义image配置
const defaultImageProp: ImageProp = {
  objectFit: 'Contain',
  margin: 0,
  webp: false
};

class HTMLParser {
  public results: HtmlParserResult = {
    nodes: [],
  }
  private customHandler: CustomHandler = defaultCustomHandler;
  private imageProp: ImageProp = defaultImageProp;
  private last: string = '';
  private stack: Stack<string> = new Stack();
  private bufArray: NodeInfo[] = [];

  constructor(customHandler?: CustomHandler, imageProp?: ImageProp) {
    customHandler && (this.customHandler = customHandler);
    imageProp && Object.assign(this.imageProp, imageProp);
  }

  start(tag: string, attrs: Attribute[], unary: boolean) {
    // node for this element
    const node: NodeInfo = new Node(tag);

    let parent: NodeInfo;
    if (this.bufArray.length !== 0) {
      parent = this.bufArray[0];
      if (!parent.nodes) {
        parent.nodes = [];
      }
    }

    if (block[tag]) {
      node.tagType = 'block';
    } else if (inline[tag]) {
      node.tagType = 'inline';
    } else if (closeSelf[tag]) {
      node.tagType = 'closeSelf';
    }
    node.attr = attrs?.reduce((pre: Record<string, string | (string | string[])[]>, attr) => {
      // const { name, value } = attr; // v4不支持对象解构
      const name = attr.name;
      const value = attr.value;
      // 优化样式相关属性
      if (name === 'style') {
        const styleObj = parseStyle(value); // parse to object
        node.artUIStyleObject = parseToArtUI(styleObj);
      } else if (value.match(/ /)) {
        // make it array of attribute
        pre[name] = value.split(' ');
      }
      // if attr already exists
      // merge it
      else if (pre[name]) {
        if (Array.isArray(pre[name])) {
          // already array, push to last
          (pre[name] as string[]).push(value);
        } else {
          // single value, make it array
          pre[name] = [pre[name] as string[], value];
        }
      } else {
        // 过滤属性
        if (!filterAttrs[name]) {
          pre[name] = value;
        }
      }
      return pre;
    }, {});

    // 对img添加额外数据
    if (node.tag === 'img') {
      let imgUrl = node.attr.src;
      if (!imgUrl) return;
      imgUrl = urlToHttpUrl(imgUrl);
      // webp替换
      if (this.imageProp.webp) {
        imgUrl = replaceWebpPic(imgUrl)
      }
      node.attr.src = imgUrl || '';

      this.assignArtUIStyleObject(node, {
        width: node?.artUIStyleObject?.width || node.attr.width,
        height: node?.artUIStyleObject?.height || node.attr.height,
        objectFit:
        this.imageProp.objectFit === 'Cover' ? ImageFit.Cover :
          this.imageProp.objectFit === 'Auto' ? ImageFit.Auto :
            this.imageProp.objectFit === 'Fill' ? ImageFit.Fill :
              this.imageProp.objectFit === 'ScaleDown' ? ImageFit.ScaleDown :
                this.imageProp.objectFit === 'None' ? ImageFit.None :
                ImageFit.Contain,
        margin: this.imageProp.margin
      })
    }

    // 处理video标签样式属性
    if (node.tag === 'video') {
      this.assignArtUIStyleObject(node, {
        width: node?.artUIStyleObject?.width || node.attr.width || '100%',
        height: node?.artUIStyleObject?.height || node.attr.height || '100%'
      })
    }

    // 处理font标签样式属性
    if (node.tag === 'font') {
      const styleAttrs = {
        color: 'fontColor',
        face: 'fontFamily',
        size: 'fontSize',
      };
      if (!node.artUIStyleObject) node.artUIStyleObject = {};
      for (let [k, v] of Object.entries(styleAttrs)) {
        const value = node.attr[k];
        if (value) {
          node.artUIStyleObject[v] = value;
        }
      }
    }

    // 临时记录source资源
    if (node.tag === 'source') {
      this.results.source = node.attr.src;
    }

    this.customHandler?.start?.(node, this.results);

    // 子节点继承父节点样式(需要排除不需要继承的样式)

    const htmlStyles = setHtmlAttributes(node.tag);

    // 整合父标签过滤之后的可继承样式+标签默认样式+自身style样式
    node.artUIStyleObject = Object.assign({
    }, excludeExtendsParentArtUIStyle(parent?.artUIStyleObject), htmlStyles, node.artUIStyleObject);

    if (unary) {
      // if this tag doesn't have end tag
      // like <img src="hoge.png"/>
      // add to parents
      const parent = this.bufArray[0] || this.results;
      if (!parent.nodes) {
        parent.nodes = [];
      }

      parent.nodes.push(node);
    } else {

      this.bufArray.unshift(node);
    }
  }

  html2json(html: string) {
    // 在 HTML 解析过程中，通常我们会先处理结束标签（end tag）再处理开始标签（start tag）。这是因为在解析HTML的过程中，我们需要确保标签的嵌套是正确的，即开始标签和结束标签的配对应该是正确的
    // 处理字符串
    this.last = html;
    html = removeDOCTYPE(html);
    html = trimHtml(html);
    html = strDiscode(html);
    let chars, index, match;
    while (html) {
      chars = true;
      if (!this.stack.last() || !special[this.stack.last()]) {
        // Comment
        if (html.startsWith('<!--')) {
          index = html.indexOf('-->');

          if (index >= 0) {
            this.comment(html.substring(4, index));
            html = html.substring(index + 3);
            chars = false;
          }
          // end tag
        } else if (html.startsWith('</')) {
          match = html.match(endTag);

          if (match) {
            html = html.substring(match[0].length);

            match[0].replace(endTag, this.parseEndTag.bind(this));
            chars = false;
          }
          // start tag
        } else if (html.startsWith('<')) {
          match = html.match(startTag);

          if (match) {
            html = html.substring(match[0].length);
            match[0].replace(startTag, this.parseStartTag.bind(this));
            chars = false;
          }
        }
        if (chars) {
          index = html.indexOf('<');
          let text = '';
          while (index === 0) {
            text += '<';
            html = html.substring(1);
            index = html.indexOf('<');
          }
          text += index < 0 ? html : html.substring(0, index);
          html = index < 0 ? '' : html.substring(index);
          this.chars(text);
        }
      } else {
        // 处理style，script标签
        html = html.replace(new RegExp('([\\s\\S]*?)<\/' + this.stack.last() + '[^>]*>'), function (all, text) {
          text = text.replace(/<!--([\s\S]*?)-->|<!\[CDATA\[([\s\S]*?)]]>/g, '$1$2');
          this.chars(text);
          return '';
        });
        this.parseEndTag('', this.stack.last());
      }
      if (html === this.last) throw new Error(`Parse Error: ${html}`);
      this.last = html;
    }

    this.parseEndTag(undefined, undefined);
    return this.results;
  }

  // tag不可删除，replace函数使用
  private parseEndTag(tag?: string | Record<string, string>, tagName?: string) {
    // If no tag name is provided, clean shop
    let pos = tagName ? this.stack.lastIndexOf(tagName.toLowerCase()) : 0;
    if (pos >= 0) {
      // Close all the open elements, up the stack
      while (this.stack.length > pos) {
        this.end(this.stack.pop() as string);
      }
    }
  }

  private parseStartTag(tag: string | Record<string, string>, tagName: string, rest: string, unary: boolean) {
    tagName = tagName.toLowerCase();
    // 处理块级标签内的内联元素
    if (block[tagName]) {
      while (this.stack.last() && inline[this.stack.last()]) {
        this.parseEndTag('', this.stack.last());
      }
    }
    // 处理自闭合标签
    if (closeSelf[tagName] && this.stack.last() === tagName) {
      this.parseEndTag('', tagName);
    }

    unary = empty[tagName] || !!unary;

    if (!unary) this.stack.push(tagName);

    const attrs: Attribute[] = [];

    // 使用正则表达式匹配属性并生成属性对象
    rest.replace(attr, (match, attributeName: string, attributeValueSingleQuote: string = '', attributeValueDoubleQuote: string = '', attributeValueNoQuote: string = '') => {
      const value = attributeValueSingleQuote || attributeValueDoubleQuote || attributeValueNoQuote || (fillAttrs[attributeName] ? attributeName : '');
      // 对属性值进行转义
      const escapedValue = value.replace(/(^|[^\\])"/g, '$1\\"');
      attrs.push({
        name: attributeName,
        value: escapedValue,
        escaped: escapedValue,
      });
      return `${attributeName}="${escapedValue}"`;
    });
    this.start(tagName, attrs, unary);
  }

  private end(tag: string) {
    // merge into parent tag
    const node = this.bufArray.shift();
    if (node.tag !== tag) {
      console.error('invalid state: mismatch end tag');
    }

    // 当有缓存source资源时于于video补上src资源
    if (node.tag === 'video' && this.results.source) {
      node.attr.src = this.results.source;
      delete this.results.source;
    }

    this.customHandler?.end?.(node, this.results);

    if (this.bufArray.length === 0) {
      this.results.nodes.push(node);
    } else {
      const parent = this.bufArray[0];
      if (!parent.nodes) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    }
  }

  private chars(text: string) {
    if (!text?.trim()) return;

    const node: SimpleNode = {
      node: 'text',
      text,
    };

    this.customHandler?.chars?.(node, this.results);

    if (this.bufArray.length === 0) {
      this.results.nodes.push(node);
    } else {
      const parent = this.bufArray[0];
      if (!parent.nodes) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    }
  }

  private comment(text: string) {
    const node: SimpleNode = {
      node: 'comment',
      text
    };
    const parent = this.bufArray[0];

    if (!parent.nodes) {
      parent.nodes = [];
    }
    parent.nodes.push(node);
  }

  private assignArtUIStyleObject<T>(node: NodeInfo, artUIStyleObject: T) {
    if (!node.artUIStyleObject) node.artUIStyleObject = {};
    Object.assign(node.artUIStyleObject, artUIStyleObject)
  }
}


export default HTMLParser;
