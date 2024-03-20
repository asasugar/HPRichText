import type { StyleObject, ArtStyleObject } from '../../types/htmlParser';
import { attrsMap, headingStyles, specialStyles, attrEnums } from './constants';

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
export function excludeExtendsParentArtUIStyle(style: ArtStyleObject) {
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
export function setHtmlAttributes(tagName: string) {
  // 使用对象映射查找并返回对应标签的样式
  const predefinedStyle = (headingStyles[tagName] || specialStyles[tagName]) || {};
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