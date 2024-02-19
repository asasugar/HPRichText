/**
 * htmlParser改造自: https://github.com/blowsie/Pure-JavaScript-HTML5-Parser
 */
import { attr, block, closeSelf, empty, endTag, fillAttrs, inline, startTag } from './index';

function HTMLParser(html, handler) {
  let index;
  let chars;
  let match;
  let last = html;
  const stack = [];
  // @ts-ignore
  stack.last = () => stack[stack.length - 1];

  function parseEndTag(tag, tagName) {
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
        if (handler.end) handler.end(stack[i]);
      }

      // Remove the open elements from the stack
      stack.length = pos;
    }
  }

  function parseStartTag(tag, tagName, rest, unary) {
    tagName = tagName.toLowerCase();

    if (block[tagName]) {
      // @ts-ignore
      while (stack.last() && inline[stack.last()]) {
        // @ts-ignore
        parseEndTag('', stack.last());
      }
    }
    // @ts-ignore
    if (closeSelf[tagName] && stack.last() === tagName) {
      parseEndTag('', tagName);
    }

    unary = empty[tagName] || !!unary;


    if (!unary) {
      console.log('1', JSON.stringify(tagName))

      stack.push(tagName);
    }
    console.log('2', JSON.stringify(stack))

    if (handler.start) {
      const attrs = [];

      rest.replace(attr, function genAttr(matches, name) {
        const value = arguments[2] || arguments[3] || arguments[4] || (fillAttrs[name] ? name : '');

        attrs.push({
          name,
          value,
          escaped: value.replace(/(^|[^\\])"/g, '$1\\"'), // "
        });
      });

      if (handler.start) {
        console.log('123456', tagName, JSON.stringify(handler), unary)

        handler.start(tagName, attrs, unary);
      }
    }
  }

  while (html) {
    chars = true;

    if (html.indexOf('</') === 0) {
      match = html.match(endTag);

      if (match) {
        html = html.substring(match[0].length);
        match[0].replace(endTag, parseEndTag);
        chars = false;
      }

      // start tag
    } else if (html.indexOf('<') === 0) {
      match = html.match(startTag);

      if (match) {
        html = html.substring(match[0].length);
        match[0].replace(startTag, parseStartTag);
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

      if (handler.chars) handler.chars(text);
    }

    if (html === last) throw new Error(`Parse Error: ${html}`);
    last = html;
  }

  // Clean up any remaining tags
  // @ts-ignore
  parseEndTag();
}


export default HTMLParser
