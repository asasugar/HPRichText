import { strDiscode } from './discode';
import HTMLParser from './html-parser';


function removeDOCTYPE(html) {
  const isDocument = /<body.*>([^]*)<\/body>/.test(html);
  return isDocument ? RegExp.$1 : html;
}

function trimHtml(html) {
  return html
    .replace(/<!--.*?-->/gi, '')
    .replace(/\/\*.*?\*\//gi, '')
    .replace(/[ ]+</gi, '<')
    .replace(/<script[^]*<\/script>/gi, '')
    .replace(/<style[^]*<\/style>/gi, '');
}

function html2json(html) {
  // 处理字符串
  html = removeDOCTYPE(html);
  html = trimHtml(html);
  html = strDiscode(html);
  return new HTMLParser(html).results;
}

export default html2json;