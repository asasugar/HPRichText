import { BorderStyle, TextAlign, TextDecorationType, TextOverflow } from '../../types/artUIEnum';
import type { AttrEnums, AttrsMap } from '../../types/consants';

// 支持的html样式key转化为鸿蒙样式key
export const attrsMap: AttrsMap = {
  'width': 'width',
  'height': 'height',
  'max-width': 'maxWidth',
  'max-height': 'maxHeight',
  'min-width': 'minWidth',
  'min-height': 'minHeight',
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
  'background-size': 'backgroundImageSize',
  'background-position': 'backgroundImagePosition',
  'rotate': 'rotate',
  'scale': 'scale',
  'offset': 'offset',
  'visibility': 'visibility',
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


// 指定的鸿蒙样式key转化为具体的enum值
export const attrEnums: AttrEnums = {
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

export const specialAttrsMap = {
  'writing-mode': 'writingMode', // 通过设置fontSize跟width一致的方式实线，https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs-V5/faqs-arkui-91-V5
}
