import { Color, FontStyle, FontWeight, TextAlign, TextDecorationType, Visibility } from '../../types/artUIEnum';
import type { HeadingStyle, SpecialStyles } from '../../types/consants';
import type { ArtStyleObject, StyleObject } from '../../types/htmlParser';
import { attrEnums, attrsMap } from './constants';

/**
 * @description: 将首字母转化为大写
 * @param {string} str: asasugar
 * @returns {*} Asasugar
 */
export function firstLetterToLowerCase(str: string): string {
  if (!str) return '';
  return str.toLowerCase().replace(/( |^)[a-z]/g, (L) => L.toUpperCase());
}

/**
 * @description: 格式化传入的Web端css样式
 * @param {*} composeCss: Web端css样式
 * @returns {*} 鸿蒙样式
 */
export function parseToArtUI(composeCss: StyleObject): ArtStyleObject {

  let obj: ArtStyleObject = {};
  if (!composeCss) return obj;
  for (const attr in composeCss) {
    const harmonyKey: string | Record<string, string[]> = attrsMap[attr];
    if (harmonyKey) {
      if (harmonyKey instanceof Object) {
        const transformedStyle = transformObject(composeCss[attr], harmonyKey);
        Object.assign(obj, transformedStyle);
      } else {
        obj[harmonyKey] = composeCss[attr];
      }
    }

  }
  return obj;
}


/**
 * @description: 转化单个鸿蒙样式的辅助方法
 * @param {string} originalValue: '10px dashed #0000FF'
 * @param {Record<string,string[]>} map: {"border": ['width', 'style', 'color']}
 * @returns {*} {width: '10px', style: TextDecorationType.Dashed, color: '#0000FF'}
 */
export function transformObject(originalValue: string, map: Record<string, string[]>) {
  const transformedObject: ArtStyleObject = {};

  for (const harmonyKey in map) {
    if (map.hasOwnProperty(harmonyKey)) {

      const newValue = (originalValue as string).split(' ');
      const mappedObject = {};
      let lastValue;
      for (let i = 0; i < map[harmonyKey].length; i++) {
        const childKey = map[harmonyKey][i];

        const value = newValue[i]; // 如：padding/margin 设置 一个值，则newValue[i]只有i=0的时候有值
        const attrEnum = attrEnums?.[harmonyKey]?.[childKey]?.[value];
        // 匹配鸿蒙属性枚举值
        if (attrEnum !== undefined) {
          mappedObject[childKey] = attrEnum;
        } else {
          mappedObject[childKey] = value || lastValue;
          if (value) {
            lastValue = value;
          }
        }
      }
      transformedObject[harmonyKey] = mappedObject;
    }
  }
  return transformedObject;
}


// 过滤和设置一些不需要继承的父级标签样式
export function excludeExtendsParentArtUIStyle(style?: ArtStyleObject) {
  if (!style) return {};
  return {
    ...style,
    border: {}, // 不继承border属性
    margin: {
      right: style?.margin?.right, left: style?.margin?.left
    },
    padding: {
      right: style?.padding?.right, left: style?.padding?.left
    }
  }
}

/**
 * @description: 设置HTML标签的初始样式
 * @param {string} tagName 标签
 * @returns {*}
 */
export function setHtmlAttributes(baseFontSize: number, baseFontColor: string, tagName?: string,) {
  if (!tagName) return {};
  // 使用对象映射查找并返回对应标签的样式
  const predefinedStyle = (headingStyles(baseFontSize, baseFontColor)[tagName] || specialStyles(baseFontSize, baseFontColor)[tagName]) || {
  };
  return predefinedStyle;
}

export function parseStyle(styleStr: string): StyleObject {
  return styleStr.split(';').reduce((styleObj: Record<string, string>, styleItem: string) => {
    const [key, value] = styleItem.trim().split(':');
    if (key && value) {
      styleObj[key] = value.trim();
    }
    return styleObj;
  }, {});
}

/**
 * @description: 定义标题标签和对应的样式映射对象
 * @param {number} baseFontSize 基准字体大小
 * @param {string} baseFontColor 基准字体色值
 * @returns {*} HeadingStyle
 */
export function headingStyles(baseFontSize: number, baseFontColor: string): HeadingStyle {
  const baseStyles: HeadingStyle = {
    h1: {
      fontWeight: FontWeight.Bold,
      fontSize: 2.5 * baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 0.9375 * baseFontSize, bottom: 0.9375 * baseFontSize }
    },
    h2: {
      fontWeight: FontWeight.Bold,
      fontSize: 1.875 * baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 0.8375 * baseFontSize, bottom: 0.8375 * baseFontSize }
    },
    h3: {
      fontWeight: FontWeight.Bold,
      fontSize: 1.46 * baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 0.8125 * baseFontSize, bottom: 0.8125 * baseFontSize }
    },
    h4: {
      fontWeight: FontWeight.Bold,
      fontSize: 1.125 * baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 0.9375 * baseFontSize, bottom: 0.9375 * baseFontSize }
    },
    h5: {
      fontWeight: FontWeight.Bold,
      fontSize: baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 0.975 * baseFontSize, bottom: 0.975 * baseFontSize }
    },
    h6: {
      fontWeight: FontWeight.Bold,
      fontSize: 0.8375 * baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 1.0625 * baseFontSize, bottom: 1.0625 * baseFontSize }
    }
  };
  return baseStyles;
}

/**
 * @description: 定义其他样式标签默认样式映射对象
 * @param {number} baseFontSize 基准字体大小
 * @returns {*} SpecialStyles
 */
export function specialStyles(baseFontSize: number, baseFontColor: string): SpecialStyles {
  const baseStyles: SpecialStyles = {
    b: { fontWeight: FontWeight.Bold, fontColor: baseFontColor },
    strong: { fontWeight: FontWeight.Bold, fontColor: baseFontColor },
    p: {
      fontSize: baseFontSize,
      fontColor: baseFontColor,
      margin: { top: 0.625 * baseFontSize, bottom: 0.625 * baseFontSize }
    },
    div: { fontSize: baseFontSize, fontColor: baseFontColor },
    i: { fontStyle: FontStyle.Italic, fontColor: baseFontColor },
    cite: { fontStyle: FontStyle.Italic, fontColor: baseFontColor },
    em: { fontStyle: FontStyle.Italic, fontColor: baseFontColor },
    var: { fontStyle: FontStyle.Italic, fontColor: baseFontColor },
    address: { fontStyle: FontStyle.Italic, fontColor: baseFontColor },
    pre: {
      fontFamily: 'monospace',
      fontColor: baseFontColor,
      backgroundColor: '#f5f5f5',
      padding: 0.625 * baseFontSize,
      margin: { top: 0.625 * baseFontSize, bottom: 0.625 * baseFontSize }
    },
    code: { fontColor: baseFontColor, fontFamily: 'monospace', backgroundColor: '#f5f5f5' },
    tt: { fontFamily: 'monospace', fontColor: baseFontColor },
    kbd: { fontFamily: 'monospace', fontColor: baseFontColor },
    samp: { fontFamily: 'monospace', fontColor: baseFontColor },
    big: { fontSize: 1.75 * baseFontSize, fontColor: baseFontColor },
    small: { fontSize: 0.9 * baseFontSize, fontColor: baseFontColor },
    sub: { fontSize: 0.75 * baseFontSize, fontColor: baseFontColor }, // 0.625 * baseFontSize
    sup: { fontSize: 0.75 * baseFontSize, fontColor: baseFontColor }, // -0.625 * baseFontSize
    s: { decoration: { type: TextDecorationType.LineThrough }, fontColor: baseFontColor },
    strike: { decoration: { type: TextDecorationType.LineThrough }, fontColor: baseFontColor },
    del: { decoration: { type: TextDecorationType.LineThrough }, fontColor: baseFontColor },
    a: { fontColor: Color.Blue, decoration: { type: TextDecorationType.Underline, color: Color.Blue } },
    video: {
      textAlign: TextAlign.Center,
      margin: { top: 0.75 * baseFontSize, bottom: 0.75 * baseFontSize },
      fontColor: baseFontColor
    },
    blockquote: {
      fontColor: baseFontColor,
      margin: { top: 0.75 * baseFontSize, bottom: 0.75 * baseFontSize },
      padding: { top: 1.5 * baseFontSize, bottom: 1.5 * baseFontSize, left: 1.5 * baseFontSize }
    },
    ol: {
      margin: { top: 1.25 * baseFontSize, bottom: 1.25 * baseFontSize },
      padding: { left: 2.125 * baseFontSize },
      fontColor: baseFontColor
    },
    ul: {
      margin: { top: 1.25 * baseFontSize, bottom: 1.25 * baseFontSize },
      padding: { left: 2.125 * baseFontSize },
      fontColor: baseFontColor
    },
    u: { decoration: { type: TextDecorationType.Underline }, fontColor: baseFontColor },
    hide: { visibility: Visibility.None, fontColor: baseFontColor },
    input: { fontSize: baseFontSize, fontColor: baseFontColor },
    textarea: { fontSize: baseFontSize, fontColor: baseFontColor },
  };
  return baseStyles;
}
