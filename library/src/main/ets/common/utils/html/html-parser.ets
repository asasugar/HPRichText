/**
 * htmlParser改造自: https://github.com/blowsie/Pure-JavaScript-HTML5-Parser
 */
import type { Attribute, NodeInfo, TextNode } from '../../types/HtmlParser';

import { parseStyle, parseToArtUI } from '../css/index';
import { strDiscode, urlToHttpUrl } from './discode';
import { attr, block, closeSelf, empty, endTag, fillAttrs, inline, removeDOCTYPE, startTag, trimHtml } from './index';
import Node from './node';
import Stack from './stack';

class HTMLParser {
  private last: string = '';
  private stack: Stack<string> = new Stack();
  private bufArray: NodeInfo[] = [];
  public results: {
    nodes: NodeInfo[];
    imageUrls: string[];
    source?: string
  } = {
    nodes: [],
    imageUrls: [],
  }

  private parseEndTag(tagName?: string) {
    // If no tag name is provided, clean shop
    let pos = tagName ? this.stack.lastIndexOf(tagName.toLowerCase()) : 0;
    if (pos >= 0) {
      // Close all the open elements, up the stack
      while (this.stack.length > pos) {
        this.end(this.stack.pop());
      }
    }
    // let pos;
    // if (!tagName) {
    //   pos = 0;
    // } else {
    //   // Find the closest opened tag of the same type
    //   tagName = tagName.toLowerCase();
    //   for (pos = this.stack.length - 1; pos >= 0; pos -= 1) {
    //     if (this.stack[pos] === tagName) break;
    //   }
    // }
    // if (pos >= 0) {
    //   // Close all the open elements, up the stack
    //   for (let i = this.stack.length - 1; i >= pos; i -= 1) {
    //     this.end(this.stack[i]);
    //   }
    //
    //   // Remove the open elements from the stack
    //   this.stack.length = pos;
    // }
  }

  private parseStartTag(tag: any, tagName: string, rest: string, unary: boolean) {
    tagName = tagName.toLowerCase();
    // 处理块级标签内的内联元素
    if (block[tagName]) {
      while (this.stack.last() && inline[this.stack.last()]) {
        this.parseEndTag(this.stack.last());
      }
    }
    // 处理自闭合标签
    if (closeSelf[tagName] && this.stack.last() === tagName) {
      this.parseEndTag(tagName);
    }

    unary = empty[tagName] || !!unary;

    if (!unary) this.stack.push(tagName);

    const attrs: Attribute[] = [];

    // 使用正则表达式匹配属性并生成属性对象
    rest.replace(attr, function genAttr(match, attributeName, attributeValueSingleQuote = '', attributeValueDoubleQuote = '', attributeValueNoQuote = '') {
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

  start(tag: string, attrs: Attribute[], unary: boolean) {
    // node for this element
    const node: NodeInfo = new Node(tag);

    if (this.bufArray.length !== 0) {
      const parent = this.bufArray[0];
      if (parent.nodes === undefined) {
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
    node.attr = attrs?.reduce((pre, attr) => {
      const { name ,value} = attr;
      if (name === 'class') {
        node.classStr = value;
      }
      // make it array of attribute
      if (name !== 'style' && value.match(/ /)) {
        pre[name] = value.split(' ');
      }
      // if attr already exists
      // merge it
      else if (pre[name]) {
        if (Array.isArray(pre[name])) {
          // already array, push to last
          pre[name].push(value);
        } else {
          // single value, make it array
          pre[name] = [pre[name], value];
        }
      } else {
        // not exist, put it
        pre[name] = value;
      }

      return pre;
    }, {});
    // 优化样式相关属性
    if ('style' in node.attr) {
      const styleObj = parseStyle(node.attr.style as string); // parse to object
      node.artUIStyleObject = parseToArtUI(styleObj) as TextAttribute
    }
    if (node.classStr) {
      node.classStr += ` ${node.tag}`;
    } else {
      node.classStr = node.tag;
    }
    if (node.tagType === 'inline') {
      node.classStr += ' inline';
    }

    // 对img添加额外数据
    if (node.tag === 'img') {
      let imgUrl = node.attr.src;
      imgUrl = urlToHttpUrl(imgUrl);
      Object.assign(node.attr, {
        src: imgUrl || '',
      });
      if (imgUrl) {
        this.results.imageUrls.push(imgUrl);
      }
    }

    // 处理a标签属性
    if (node.tag === 'a') {
      node.attr.href = node.attr.href || '';
    }

    // 处理font标签样式属性
    if (node.tag === 'font') {
      const fontSize = [
        'x-small',
        'small',
        'medium',
        'large',
        'x-large',
        'xx-large',
        '-webkit-xxx-large',
      ];
      const styleAttrs = {
        color: 'color',
        face: 'font-family',
        size: 'font-size',
      };
      if (!node.attr.style) node.attr.style = {};
      Object.keys(styleAttrs).forEach((key) => {
        if (node.attr[key]) {
          const value = key === 'size' ? fontSize[node.attr[key] - 1] : node.attr[key];
          node.attr.style[styleAttrs[key]] = value;
        }
      });
    }

    // 临时记录source资源
    if (node.tag === 'source') {
      this.results.source = node.attr.src;
    }

    if (unary) {
      // if this tag doesn't have end tag
      // like <img src="hoge.png"/>
      // add to parents
      const parent = this.bufArray[0] || this.results;
      if (parent.nodes === undefined) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    } else {
      this.bufArray.unshift(node);
    }
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
    if (!text.trim()) return;

    const node: TextNode = {
      node: 'text',
      text,
    };

    if (this.bufArray.length === 0) {
      this.results.nodes.push(node);
    } else {
      const parent = this.bufArray[0];
      if (parent.nodes === undefined) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    }
  }

  html2json(html: string): {
    nodes: NodeInfo[];
    imageUrls: string[];
    source?: string
  } {
    // 在 HTML 解析过程中，通常我们会先处理结束标签（end tag）再处理开始标签（start tag）。这是因为在解析HTML的过程中，我们需要确保标签的嵌套是正确的，即开始标签和结束标签的配对应该是正确的
    // 处理字符串
    html = removeDOCTYPE(html);
    html = trimHtml(html);
    html = strDiscode(html);
    let chars, index, match;
    while (html) {
      chars = true;

      if (html.startsWith('</')) {
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

      if (html === this.last) throw new Error(`Parse Error: ${html}`);
      this.last = html;
    }

    this.parseEndTag();
    return this.results;
  }
}


export default HTMLParser;
