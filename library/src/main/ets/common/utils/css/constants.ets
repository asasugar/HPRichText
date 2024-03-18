export const attrsMap = {
  'flex-basis': 'flexBasis',
  'flex-grow': 'flexGrow',
  'flex-shrink': 'flexShrink',
  'align-self': 'alignSelf',
  // 'clip': 'clip', 已废弃
  'width': 'width',
  'height': 'height',
  'z-index': 'zIndex',
  'margin': { margin: ['top', 'right', 'bottom', 'left'] },
  'padding': { padding: ['top', 'right', 'bottom', 'left'] },
  'border': { border: ['width', 'style', 'color'] },
  'border-style': 'borderStyle',
  'border-width': 'borderWidth',
  'border-color': 'borderColor',
  'border-radius': 'borderRadius',
  'opacity': 'opacity',
  'background-color': 'backgroundColor',
  'background-image': 'backgroundImage',
  'background-repeat': 'backgroundRepeat',
  'background-size': 'backgroundImageSize',
  'background-position': 'backgroundImagePosition',
  'rotate': 'rotate',
  'scale': 'scale',
  'translate': 'translate',
  'transform': 'transform',
  'visibility': 'visibility',
  // 'position':'position',
  // 'shadow':'shadow',
  'offset': 'offset',
  'text-decoration': { decoration: ['type', 'color'] },
  'text-overflow': { textOverflow: ['overflow'] },
  '-webkit-line-clamp': 'maxLines',
  'line-height': 'lineHeight',
  'letter-spacing': 'letterSpacing',
  'color': 'fontColor',
  'font-size': 'fontSize',
  'font-style': 'fontStyle',
  'font-weight': 'fontWeight',
  'font-family': 'fontFamily',
  'text-align': 'textAlign',
};

export const attrEnums = {
  'border': {
    style: {
      'solid': BorderStyle.Solid,
      'dashed': BorderStyle.Dashed,
      'dotted': BorderStyle.Dotted,
    }
  },
  'decoration': {
    type: {
      'underline': TextDecorationType.Underline,
      'line-through': TextDecorationType.LineThrough,
      'overline': TextDecorationType.Overline,
      'none': TextDecorationType.None
    }
  },
  'textAlign': { left: TextAlign.Start, center: TextAlign.Center, right: TextAlign.End },
  'textOverflow': {
    overflow: {
      'ellipsis': TextOverflow.Ellipsis,
      'clip': TextOverflow.Clip,
      'none': TextOverflow.None
    }
  }
}
// 不处理的样式
// 'linear-gradient', 'clip'

// 定义标题标签和对应的样式映射对象
export const headingStyles = {
  h1: { fontWeight: FontWeight.Bold, fontSize: 40, margin: { top: 15, bottom: 15 } },
  h2: { fontWeight: FontWeight.Bold, fontSize: 30, margin: { top: 13.4, bottom: 13.4 } },
  h3: { fontWeight: FontWeight.Bold, fontSize: 23.4, margin: { top: 13, bottom: 13 } },
  h4: { fontWeight: FontWeight.Bold, fontSize: 18, margin: { top: 15, bottom: 15 } },
  h5: { fontWeight: FontWeight.Bold, fontSize: 16.6, margin: { top: 15.6, bottom: 15.6 } },
  h6: { fontWeight: FontWeight.Bold, fontSize: 13.4, margin: { top: 17, bottom: 17 } }
}

// 定义特殊样式标签及其样式映射对象
export const specialStyles = {
  b: { fontWeight: FontWeight.Bold },
  strong: { fontWeight: FontWeight.Bold },
  p: { margin: { top: 10, bottom: 10 } },
  i: { fontStyle: FontStyle.Italic },
  cite: { fontStyle: FontStyle.Italic },
  em: { fontStyle: FontStyle.Italic },
  var: { fontStyle: FontStyle.Italic },
  address: { fontStyle: FontStyle.Italic },
  pre: { fontFamily: 'monospace', backgroundColor: '#f5f5f5', padding: 10, margin: { top: 10, bottom: 10 } },
  code: { fontFamily: 'monospace', backgroundColor: '#f5f5f5' },
  tt: { fontFamily: 'monospace' },
  kbd: { fontFamily: 'monospace' },
  samp: { fontFamily: 'monospace' },
  big: { fontSize: 28 },
  small: { fontSize: 16.6 },
  sub: { fontSize: 12, offset: { y: 10 } },
  sup: { fontSize: 12, offset: { y: -10 } },
  s: { decoration: { type: TextDecorationType.LineThrough } },
  strike: { decoration: { type: TextDecorationType.LineThrough } },
  del: { decoration: { type: TextDecorationType.LineThrough } },
  a: { fontColor: Color.Blue, decoration: { type: TextDecorationType.Underline, color: Color.Blue } },
  video: { textAlign: TextAlign.Center, magin: { top: 12, bottom: 12 } },
  blockquote: { margin: { top: 12, bottom: 12 }, padding: { top: 24, bottom: 24, left: 24 } },
  ol: { margin: { top: 20, bottom: 20 }, padding: { left: 34 } },
  ul: { margin: { top: 20, bottom: 20 }, padding: { left: 34 } },
  u: { decoration: { type: TextDecorationType.Underline } },
  hide: { visibility: Visibility.None },
  // table: { width: '100%' },
  // tr: { width: '100%', border: { width: 1, color: '#e0e0e0' } }
};
