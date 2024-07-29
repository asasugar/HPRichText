export function makeMap(str: string) {
  const obj: Record<string, boolean> = {};
  const items = str.split(',');
  for (let i = 0; i < items.length; i += 1) {
    obj[items[i]] = true;
  }
  return obj;
}

export function removeDOCTYPE(html: string) {
  const isDocument = /<body.*>([^]*)<\/body>/.test(html);
  return isDocument ? RegExp.$1 : html;
}

export function trimHtml(html: string) {
  return html
    .replace(/<!--.*?-->/gi, '')
    .replace(/\/\*.*?\*\//gi, '')
    .replace(/[ ]+</gi, '<')
    .replace(/<script[^]*<\/script>/gi, '')
    .replace(/<style[^]*<\/style>/gi, '');
}

export function replaceBr(html: string) {
  const reg = /<br\s*\/?>/gi;
  return html.replace(reg, '\n');
}

export function replaceEscapeSymbol(html: string) {
  const reg = /\t/gi;
  return html.replace(reg, '\t\t');
}

export function addRootDiv(html: string) {
  if (!html) {
    return html;
  }
  return `<div>${html}</div>`
}

export function startWithHTMLElement(html: string) {
  // 正则表达式匹配以 < 开头，后跟非空白字符，直至遇到 > 为止的序列
  const reg = /^<\w+(\s+\w+="[^"]*"|\s+\w+='[^']*'|\s+[^\s>]+)*\s*>/;
  return reg.test(html.replace(/\n/g, ""));
}

export const startTag =
  /^<([-A-Za-z0-9_]+)((?:\s+[a-zA-Z0-9_:][-a-zA-Z0-9_:.]*(?:\s*=\s*(?:(?:"[^"]*")|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>/;

export const endTag = /^<\/([-A-Za-z0-9_]+)[^>]*>/;

export const attr =
  /([a-zA-Z0-9_:][-a-zA-Z0-9_:.]*)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?/g;

// Empty Elements - HTML 5
export const empty =
  makeMap('area,base,basefont,br,col,frame,hr,img,input,link,meta,param,embed,command,keygen,source,track,wbr');

// Block Elements - HTML 5
export const block =
  makeMap('img,input,textarea,br,code,address,article,applet,aside,audio,blockquote,canvas,center,dd,dir,div,dl,dt,fieldset,figcaption,figure,footer,form,frameset,h1,h2,h3,h4,h5,h6,header,hgroup,hr,iframe,ins,isindex,li,map,menu,noframes,noscript,ol,output,p,pre,section,script,table,tbody,td,tfoot,th,thead,tr,ul,video');

// Inline Elements - HTML 5
export const inline =
  makeMap('a,abbr,acronym,b,basefont,bdo,big,button,cite,del,dfn,em,font,i,iframe,ins,kbd,label,object,q,s,samp,script,select,small,span,strike,strong,sub,sup,tt,u,var');

// Elements that you can, intentionally, leave open
// (and which close themselves)
export const closeSelf = makeMap('colgroup,dd,dt,li,options,p,td,tfoot,th,thead,tr');

// Attributes that have their values filled in disabled="disabled"
export const fillAttrs =
  makeMap('checked,compact,declare,defer,disabled,ismap,multiple,nohref,noresize,noshade,nowrap,readonly,selected');

// node转化之后需要过滤的属性
export const filterAttrs = makeMap('style,class');

export const special = makeMap('script,style');

// 将图片替换成webp格式
export function replaceWebpPic(imgUrl: string): string {
  if (!imgUrl || typeof imgUrl !== 'string') {
    return imgUrl;
  }
  const reg = /(http)(s)?:\/\/(img|static)(.*?)\.(png|jpg|gif|jpeg|bmp)(?!_.webp)/gi;
  if (imgUrl.match(reg)) {
    imgUrl = imgUrl.replace(reg, img => {
      return `${img}_.webp`;
    });
  }
  return imgUrl;
}
