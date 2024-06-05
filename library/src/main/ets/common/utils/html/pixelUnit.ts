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

  // 正则表达式匹配px单位
  const regex = /(\d*\.?\d+)px/g;
  return htmlContent.replace(regex, (match, p1) => {
    // 将匹配到的px值乘以比例转换为rpx
    return `${parseInt(p1, 10) * pixelRatio}${pixelUnit}`;
  });
}
