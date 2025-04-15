/**
 * htmlParser改造自: https://github.com/blowsie/Pure-JavaScript-HTML5-Parser
 */
import type { PixelUnit, RichTextOption } from '../../../components/hprichtext/index';
import type { Resource } from '../../types/artUIBase';
import { Color, ImageFit } from '../../types/artUIEnum';
import type {
  ALinkProp,
  Attribute,
  CustomHandler,
  HtmlParserResult,
  ImageProp,
  NodeInfo,
  SimpleNode
} from '../../types/htmlParser';
import { excludeExtendsParentArtUIStyle, parseStyle, parseToArtUI, setHtmlAttributes } from '../css/index';
import { strDiscode, urlToHttpUrl } from './discode';
import {
  addRootDiv,
  attr,
  block,
  closeSelf,
  empty,
  endTag,
  fillAttrs,
  filterAttrs,
  inline,
  removeDOCTYPE,
  replaceBr,
  replaceEscapeSymbol,
  replaceWebpPic,
  special,
  startTag,
  startWithHTMLElement,
  trimHtml
} from './index';
import Node from './node';
import { px2Any } from './pixelUnit';
import Stack from './stack';

// 默认自定义标签匹配处理方法
const defaultCustomHandler: CustomHandler = {
  start(node: NodeInfo) {
    if (!node.attr) {
      node.attr = {};
    }
    // node.attr.class = null;
    // node.attr.style = null;
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

/*默认自定义的alink配置*/
const defaultAlinkProp: ALinkProp = {
  /*a标签链接的默认颜色*/
  linkColor: Color.Blue,
  /*a标签下划线的格式*/
  decoration: {
    type: 'Underline',
    color: Color.Blue
  }
}

class HTMLParser {
  public results: HtmlParserResult = {
    nodes: [],
  };
  private stack: Stack<string> = new Stack();
  private bufArray: NodeInfo[] = [];
  private customHandler: CustomHandler = defaultCustomHandler;
  private imageProp: ImageProp = defaultImageProp;
  private alinkProp: ALinkProp = defaultAlinkProp;
  private html: string = '';
  private baseFontSize: number | Resource = 16;
  private basePixelUnit: PixelUnit = 'vp';
  private basePixelRatio: number | Resource = 1;
  private baseFontColor: string | Resource = '#000000';
  private last: string = '';

  constructor(
    {
      customHandler,
      imageProp,
      alinkProp,
      baseFontSize,
      basePixelUnit,
      basePixelRatio,
      baseFontColor,
      content
    }: RichTextOption) {
    customHandler && (this.customHandler = customHandler);
    imageProp && Object.assign(this.imageProp, imageProp);
    alinkProp && Object.assign(this.alinkProp, alinkProp);
    baseFontSize && (this.baseFontSize = baseFontSize);
    basePixelUnit && (this.basePixelUnit = basePixelUnit);
    basePixelRatio && (this.basePixelRatio = basePixelRatio);
    baseFontColor && (this.baseFontColor = baseFontColor);
    content && (this.html = content);
  }

  start(tag: string, attrs: Attribute[], unary: boolean) {
    // node for this element
    const node: NodeInfo = new Node(tag);

    let parent: NodeInfo = {};
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
    node.attr = attrs?.reduce((pre: Record<string, number | string | (string | string[])[]>, attr) => {
      // const { name, value } = attr; // v4不支持对象解构
      const name = attr.name;
      let value = attr.value;
      // 优化样式相关属性
      if (name === 'style') {
        const styleObj = parseStyle(value); // parse to object
        node.artUIStyleObject = parseToArtUI(styleObj, this.baseFontSize as number);
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
          pre[name] = [pre[name] as unknown as string[], value];
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
      if (!imgUrl) {
        return;
      }
      imgUrl = urlToHttpUrl(imgUrl);
      // webp替换
      if (this.imageProp.webp) {
        imgUrl = replaceWebpPic(imgUrl);
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
        margin: node?.artUIStyleObject?.margin || this.imageProp.margin
      });
    }

    // 处理video标签样式属性
    if (node.tag === 'video') {
      this.assignArtUIStyleObject(node, {
        width: node?.artUIStyleObject?.width || node.attr.width || '100%',
        height: node?.artUIStyleObject?.height || node.attr.height || '100%'
      });
    }

    // 处理font标签样式属性
    if (node.tag === 'font') {
      const styleAttrs = {
        color: 'fontColor',
        face: 'fontFamily',
        size: 'fontSize',
      };
      if (!node.artUIStyleObject) {
        node.artUIStyleObject = {};
      }
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
    let htmlStyles = {};
    htmlStyles = setHtmlAttributes(this.baseFontSize as number, this.baseFontColor as string, this.alinkProp ,node.tag);

    // 整合父标签过滤之后的标签默认样式+可继承样式+自身style样式【顺序很重要】
    node.artUIStyleObject =
      Object.assign({}, htmlStyles, excludeExtendsParentArtUIStyle(parent?.artUIStyleObject, node),
        node.artUIStyleObject);
    // 对纯数字的lineHeight样式特别计算
    const lh: number = +(node.artUIStyleObject?.lineHeight ?? 0);
    const reg = /^\d+(\.\d+)?$/g;
    if (lh && reg.test(`${lh}`)) {
      // 带单位的 fontSize
      const originalFs: string = `${node.artUIStyleObject?.fontSize ?? this.baseFontSize}`;
      // 提取不带单位的fontSize用于lineHeight计算
      const numberStr = originalFs.replace(this.basePixelUnit, ""); // 提取数字部分
      Object.assign(node.artUIStyleObject, { 'lineHeight': `${+numberStr * lh}${this.basePixelUnit}` })
    }
    // 如果是点击事件，则增加触发事件的node节点index
    if ('onClick' in node.attr || node.tag === 'a') {
      node.attr.clickIndex = 0;
    }
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

  _dealHtmlJson(html: string = this.html): string {
    html = removeDOCTYPE(html);
    html = trimHtml(html);
    html = replaceBr(html);
    html = replaceEscapeSymbol(html);
    html = strDiscode(html);
    html = px2Any(html, this.basePixelUnit, this.basePixelRatio as number);
    // 判断字符串不是以 HTML 标签开头，则最外层增加div
    if (!startWithHTMLElement(html)) {
      html = addRootDiv(html);
    }
    return html;
  }

  html2json(html: string = this.html) {
    // 在 HTML 解析过程中，通常我们会先处理结束标签（end tag）再处理开始标签（start tag）。这是因为在解析HTML的过程中，我们需要确保标签的嵌套是正确的，即开始标签和结束标签的配对应该是正确的
    // 处理字符串
    this.last = html;
    html = this._dealHtmlJson(html);
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
      if (html === this.last) {
        throw new Error(`Parse Error: ${html}`);
      }
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

    if (!unary) {
      this.stack.push(tagName);
    }

    const attrs: Attribute[] = [];

    // 使用正则表达式匹配属性并生成属性对象
    rest.replace(attr,
      (match, attributeName: string, attributeValueSingleQuote: string = '', attributeValueDoubleQuote: string = '',
        attributeValueNoQuote: string = '') => {
        const value = attributeValueSingleQuote || attributeValueDoubleQuote || attributeValueNoQuote ||
          (fillAttrs[attributeName] ? attributeName : '');
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

    if (node?.tag !== tag) {
      console.error('invalid state: mismatch end tag');
    }

    // 当有缓存source资源时于于video补上src资源
    if (node?.tag === 'video' && this.results.source) {
      if (!node.attr) {
        node.attr = {};
      }
      node.attr.src = this.results.source;
      delete this.results.source;
    }

    this.customHandler?.end?.(node, this.results);

    if (node) {
      const hasBlockNode = node.nodes?.some(i => i.tagType === 'block');

      // html第一个节点
      if (this.bufArray.length === 0) {
        // 先判断当前第一个节点是block&&子节点不存在block节点，则添加标识
        // 然后判断当前子节点列表nodes第一项如果是纯文本||子节点列表不存在block节点则添加标识
        if (node.tagType === 'block' && !hasBlockNode) {
          node.addHarmonyTextTag = true;
        } else if (node.nodes?.length === 1 && node.nodes[0]?.node === 'text') {
          node.addHarmonyTextTag = true;
        } else if (!hasBlockNode) {
          node.addHarmonyTextTag = true;
        }
        const firstNodes = this.results.nodes;
        const firstNodesLength = firstNodes.length;
        // 判断如果一级节点存在多个子节点&&当前节点不是block&&上一个节点也不是block节点&&上一个节点存在nodes字段，则将当前节点插入上级节点的子节点nodes下
        if (firstNodesLength && node.tagType !== 'block' &&
          firstNodes[firstNodesLength-1]?.tagType !== 'block' && firstNodes[firstNodesLength-1]?.nodes) {
          firstNodes[firstNodesLength-1].nodes?.push(node);
        } else if (firstNodesLength === 0 && firstNodes[0]?.nodes) {
          // 说明是非block节点，如果this.results.nodes[0].nodes存在，则push进去
          firstNodes[0]?.nodes?.push(node);
        } else {
          firstNodes.push(node);
        }
      } else {
        // 第二个节点往后
        const parent = this.bufArray[0];
        if (!parent.nodes) {
          parent.nodes = [];
        }
        // ①：当前节点tagType === 'block' && 子节点不存在block，则添加标识
        // ②：当前节点tagType === 'inline'：
        // a.判断当前父级nodes长度为 1 && 前一个节点是inline && 父节点!==block，则上一个节点添加标识；
        // b.判断当前父级nodes长度为 1 && 前一个节点是block，则当前节点节点添加标识；
        // c.判断当前父级nodes的最后一个子节点是text节点 && 当前节点存在nodes子节点，则将 text 节点插入到当前节点的nodes数组首位并且当前节点添加标识+父节点中删除插入的节点；
        // d.判断当前父级nodes大于 1 && 前一个节点是block，则当前节点节点添加标识；

        const parentNodes = parent.nodes;
        const parentNodesLength = parentNodes.length;
        if (node.tagType === 'block' && !hasBlockNode) {
          node.addHarmonyTextTag = true;

        } else if (node.tagType === 'inline') {
          if (parentNodesLength === 1) {

            // a.判断当前父级nodes长度为 1 && 前一个节点是inline && 父节点!==block，则上一个节点添加标识；
            if (parentNodes[parentNodesLength-1]?.tagType === 'inline' && parent?.tagType !== 'block') {
              parentNodes[parentNodesLength-1].addHarmonyTextTag = true;
            } else if (parentNodes[parentNodesLength-1]?.tagType === 'block') {
              // b.判断当前父级nodes长度为 1 && 前一个节点是block，则当前节点节点添加标识；
              node.addHarmonyTextTag = true;
            } else if (parentNodes[parentNodesLength-1]?.node === 'text' && node.nodes?.length) {
              // c.判断当前父级nodes的最后一个子节点是text节点&&当前节点存在nodes子节点，则将 text 节点插入到当前节点的nodes数组首位并且当前节点添加标识+父节点中删除插入的节点；
              parentNodes[parentNodesLength-1].artUIStyleObject = parent.artUIStyleObject;
              node.nodes.unshift(parentNodes[parentNodesLength-1]);
              parentNodes.pop();
              node.addHarmonyTextTag = true;
              if (node.attr?.onClick || node.tag === 'a') {
                node.attr.clickIndex += 1;
              }
            }
          } else if (parentNodesLength > 1) {
            // d.判断当前父级nodes大于 1 && 前一个节点是block，则当前节点节点添加标识；
            if (parentNodes[parentNodesLength-1]?.tagType === 'block') {
              node.addHarmonyTextTag = true;
            }
          } else {
            // 进入这个判断则代表“父节点的子节点中存在混合inline跟block的节点，并且父节点没有设置过标识”，且当前父级nodes长度等于0，即第一个插入的当前节点是inline，则需要设置标识
            if (parent.tagType === 'block') {
              node.addHarmonyTextTag = true;
            }
          }
        }

        // 当前节点是inline且上一级也是inline，则将当前节点push到上一级节点的子节点nodes下；即[{节点 1}，{节点 2}]，若节点 1 跟 2 都是inline=>[{节点 1, nodes: [节点 2]}]
        if (node.tagType === 'inline' && parentNodes[parentNodesLength-1]?.tagType === 'inline') {
          node.isInlinePushNode = true;
          if (parentNodes[parentNodesLength-1]?.nodes) {
            parentNodes[parentNodesLength-1].nodes?.push(node);
          } else {
            parentNodes.push(node)
          }
        } else {
          parent.nodes.push(node);
        }
      }
    }
  }

  private chars(text: string) {
    if (!text?.trim()) {
      return;
    }
    const node: SimpleNode = {
      node: 'text',
      // text: text.includes('\t') ? text : text.trim(), // 制表符特殊判断
      text
    };
    this.customHandler?.chars?.(node, this.results);

    if (this.bufArray.length === 0) {

      const firstNodes = this.results.nodes;
      const firstNodesLength = firstNodes.length;
      // 判断如果一级节点存在多个子节点&&当前节点不是block&&上一个节点也不是block节点&&上一个节点存在nodes字段，则将当前节点插入上级节点的子节点nodes下
      if (firstNodesLength &&
        firstNodes[firstNodesLength-1]?.tagType !== 'block' && firstNodes[firstNodesLength-1]?.nodes) {
        firstNodes[firstNodesLength-1].isInlinePushNode = true;
        if (!this.bufArray.length) {
          node.artUIStyleObject = this.defaultArtUI();
        }
        firstNodes[firstNodesLength-1].nodes?.push(node);
      } else if (firstNodesLength === 0 && firstNodes[0]?.nodes) {
        firstNodes[0].nodes.push(node);
      } else {
        // 进入这个判断代表：这个节点内容是子节点，所以父级不是isInlinePushNode则需要继承父级的样式
        if (!firstNodes[0]?.isInlinePushNode) {
          node.artUIStyleObject = firstNodes[0].artUIStyleObject;
        }
        firstNodes.push(node);
      }
    } else {
      const parent = this.bufArray[0];
      if (!parent.nodes) {
        parent.nodes = [];
      }
      if (parent.nodes.length && parent.nodes[parent.nodes.length-1]?.tagType === 'inline' &&
        parent.nodes[parent.nodes.length-1]?.nodes) {
        node.artUIStyleObject = parent.artUIStyleObject;
        parent.nodes[parent.nodes.length-1].isInlinePushNode = true;
        parent.nodes[parent.nodes.length-1]?.nodes?.push(node);
      } else {
        parent.nodes.push(node);
      }
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
    if (!node.artUIStyleObject) {
      node.artUIStyleObject = {};
    }
    Object.assign(node.artUIStyleObject, artUIStyleObject);
  }

  private defaultArtUI() {
    return {
      fontSize: `${parseInt(String(this?.baseFontSize), 10) *
        (this.basePixelRatio as number)}${this.basePixelUnit}`,
      fontColor: this.baseFontColor as Color
    }
  }
}


export default HTMLParser;
