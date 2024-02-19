/**
 * htmlParser改造自: https://github.com/blowsie/Pure-JavaScript-HTML5-Parser
 */
import { startTag, endTag, attr, empty, block, inline, closeSelf, fillAttrs } from './index';
// import type { TagInfo, Handler } from '../../types/HtmlParser';
import display from '@ohos.display';
import { urlToHttpUrl } from './discode';


function getScreenInfo() {
  let displayClass = null;
  let screen = null;
  const PREVIEW_DISPLAY = {
    width: 1228,
    height: 2700
  };
  try {
    displayClass = display.getDefaultDisplaySync();
    // 方便previewer调试
    if (displayClass?.name?.includes('PC Preview')) {
      screen = PREVIEW_DISPLAY;
    } else {
      screen.width = displayClass.width;
      screen.height = displayClass.height;
    }
  } catch (exception) {
    console.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
  }
  return screen;
}

class Node {
  node: string;
  tag: string;
  attr: any;
  classStr: string;
  styleObj: any;
  $screen: any;
  tagType: string;

  constructor(tag) {
    this.node = 'element';
    this.tag = tag;
    const screen = getScreenInfo();
    this.$screen = screen;
  }
}

function parseStyle(styleStr) {
  return styleStr.split(';').reduce((styleObj, styleItem) => {
    const [key, value] = styleItem.trim().split(':');
    if (key && value) {
      styleObj[key] = value.trim();
    }
    return styleObj;
  }, {});
}

let index;
let chars;
let match;
const stack = [];
// @ts-ignore
stack.last = () => stack[stack.length - 1];
const bufArray = [];


class HTMLParser {
  last: string;
  results: any;

  constructor(html) {
    this.last = html;
    this.results = {
      nodes: [],
      imageUrls: [],
    };
    while (html) {
      chars = true;

      if (html.indexOf('</') === 0) {
        match = html.match(endTag);

        if (match) {
          html = html.substring(match[0].length);

          match[0].replace(endTag, this.parseEndTag.bind(this));
          chars = false;
        }

        // start tag
      } else if (html.indexOf('<') === 0) {
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

    // Clean up any remaining tags
    // @ts-ignore
    this.parseEndTag();
  }

  parseEndTag(tag, tagName) {
    // If no tag name is provided, clean shop
    let pos;
    if (!tagName) {
      pos = 0;
    } else {
      // Find the closest opened tag of the same type
      tagName = tagName.toLowerCase();
      for (pos = stack.length - 1; pos >= 0; pos -= 1) {
        if (stack[pos] === tagName) break;
      }
    }
    if (pos >= 0) {
      // Close all the open elements, up the stack
      for (let i = stack.length - 1; i >= pos; i -= 1) {
        this.end(stack[i]);
      }

      // Remove the open elements from the stack
      stack.length = pos;
    }
  }

  parseStartTag(tag, tagName, rest, unary) {
    tagName = tagName.toLowerCase();

    if (block[tagName]) {
      // @ts-ignore
      while (stack.last() && inline[stack.last()]) {
        // @ts-ignore
        this.parseEndTag('', stack.last());
      }
    }
    // @ts-ignore
    if (closeSelf[tagName] && stack.last() === tagName) {
      this.parseEndTag('', tagName);
    }

    unary = empty[tagName] || !!unary;

    if (!unary) stack.push(tagName);

    const attrs = [];

    rest.replace(attr, function genAttr(matches, name) {
      const value = arguments[2] || arguments[3] || arguments[4] || (fillAttrs[name] ? name : '');

      attrs.push({
        name,
        value,
        escaped: value.replace(/(^|[^\\])"/g, '$1\\"'), // "
      });
    });

    this.start(tagName, attrs, unary);
  }

  start(tag, attrs, unary) {
    // node for this element
    const node = new Node(tag);

    if (bufArray.length !== 0) {
      const parent = bufArray[0];
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
      const { name } = attr;
      let { value } = attr;
      if (name === 'class') {
        node.classStr = value;
      }
      // has multi attibutes
      // make it array of attribute

      if (name === 'style') {
        node.styleObj = parseStyle(value);
      }
      if (value.match(/ /)) {
        value = value.split(' ');
      }

      // if attr already exists
      // merge it
      if (pre[name]) {
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
      if (!node.styleObj) node.styleObj = {};
      Object.keys(styleAttrs).forEach((key) => {
        if (node.attr[key]) {
          const value = key === 'size' ? fontSize[node.attr[key] - 1] : node.attr[key];
          node.styleObj[styleAttrs[key]] = value;
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
      const parent = bufArray[0] || this.results;
      if (parent.nodes === undefined) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    } else {
      bufArray.unshift(node);
    }
  }

  end(tag) {
    // merge into parent tag
    const node = bufArray.shift();
    if (node.tag !== tag) {
      console.error('invalid state: mismatch end tag');
    }

    // 当有缓存source资源时于于video补上src资源
    if (node.tag === 'video' && this.results.source) {
      node.attr.src = this.results.source;
      delete this.results.source;
    }

    if (bufArray.length === 0) {
      this.results.nodes.push(node);
    } else {
      const parent = bufArray[0];
      if (!parent.nodes) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    }
  }

  chars(text) {
    if (!text.trim()) return;

    const node = {
      node: 'text',
      text,
    };

    if (bufArray.length === 0) {
      this.results.nodes.push(node);
    } else {
      const parent = bufArray[0];
      if (parent.nodes === undefined) {
        parent.nodes = [];
      }
      parent.nodes.push(node);
    }
  }
}


export default HTMLParser;
