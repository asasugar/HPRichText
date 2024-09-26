import type { PixelUnit } from '../../../components/hprichtext/index';

/**
 * @description: 富文本中px转化为指定pixelUnit的单位
 * @param {string} htmlContent: html字符串
 * @param {PixelUnit} pixelUnit: 需转化之后的像素单位
 * @param {number} pixelRatio: 像素比=屏幕宽度/设计稿宽度
 * @returns {*}
 */
export function px2Any(htmlContent: string, pixelUnit: PixelUnit = 'vp', pixelRatio: number = 1) {
  // 假设屏幕宽度为750px时，以设计稿750px为例 1vp = 1px
  const styleRegex = /style\s*=\s*['"]([^'"]*)['"]/g; // 匹配style属性正则
  const pxRegex = /(\d*\.?\d+)px/g; // 匹配px单位正则
  return htmlContent.replace(styleRegex, (match, styleContent) => {
    // 将匹配到的px值乘以比例转换为rpx
    const processedStyleContent =styleContent.replace(pxRegex,(match, p1)=>{
      return `${parseInt(p1, 10) * pixelRatio}${pixelUnit}`;
    })
    // 替换原始字符串中的style内容
    return `style='${processedStyleContent}'`;
  });
}
