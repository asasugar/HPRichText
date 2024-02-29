import type { StyleObject } from '../../types/HtmlParser';
import { attrsMap } from './constants';
/**
 * @description: 将首字母转化为大写
 * @param {string} str: auok
 * @returns {*} Auok
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
export function parseToArtUI(composeCss: StyleObject): TextAttribute {

  let obj = {} as TextAttribute;
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
  const transformedObject = {};
  for (const harmonyKey in map) {
    if (map.hasOwnProperty(harmonyKey)) {

      const newValue = (originalValue as string).split(' ');
      const mappedObject = {};

      for (let i = 0; i < map[harmonyKey].length; i++) {

        const childKey = map[harmonyKey][i];
        mappedObject[childKey] = specialAttributes(harmonyKey, childKey, newValue[i]);
      }
      transformedObject[harmonyKey] = mappedObject;
    }
  }
  return transformedObject;
}

export function specialAttributes(harmonyKey: string, childKey: string, value: string = '') {
  // decoration-type属性特殊转化
  if (harmonyKey === 'decoration' && childKey === 'type') {
    value = TextDecorationType[firstLetterToLowerCase(value)];
  }
  // border-style属性特殊转化
  if (harmonyKey === 'border' && childKey === 'style') {
    value = BorderStyle[firstLetterToLowerCase(value)];
  }
  return value;
}

export function parseStyle(styleStr: string): StyleObject {
  return styleStr.split(';').reduce((styleObj, styleItem) => {
    const [key, value] = styleItem.trim().split(':');
    if (key && value) {
      styleObj[key] = value.trim();
    }
    return styleObj;
  }, {});
}