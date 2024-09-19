import type { NodeInfo } from '../../common/types/htmlParser';
import type {
  FancySpanOptions,
  LinkPressMethod,
  LinkPressParame,
  NodesBuilderOptions,
  RichTextOption
} from './index';
import { assign } from '../../common/utils/helperful';

/**
 * @description: 判断是否需要包裹 Text 标签
 * @returns {*}
 */
export function _isNeedRenderText($$: NodesBuilderOptions) {
  const parentCanAddText = $$.parentNode?.addHarmonyTextTag;
  return !$$.alreadyAddText && (!$$.parentNode || !parentCanAddText);
}

/**
 * @description: 公共点击事件处理
 * @returns {*}
 */
export function _commonClick(node: NodeInfo, event: ClickEvent, other: LinkPressParame,
  onLinkPress?: LinkPressMethod) {
  if (!node?.attr?.onClick) {
    return;
  }
  // 增加回调事件
  try {
    onLinkPress?.(assign(other, {
      eventFnName: node?.attr?.onClick,
      clickEvent: event
    }));
  } catch (error) {
    console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
  }
}

/**
 * @description: 生成默认样式为push的子节点添加默认样式
 * @returns {*}
 */
export function _setDefaultArtUI(richTextOption: RichTextOption) {
  return {
    fontSize: `${parseInt(String(richTextOption?.baseFontSize ?? 16), 10) *
      (richTextOption.basePixelRatio as number ?? 1)}${richTextOption.basePixelUnit ?? 'vp'}`,
    fontColor: richTextOption.baseFontColor ?? '#000000'
  } as FancySpanOptions
}

/**
 * @description: 生成唯一的 key
 * @returns {*}
 */
export function getRandomKey(item: NodeInfo, index: number) {
  return Math.random().toFixed(3) + item.node + item.tag + item.tagType + index;
}

// export function getBlockIndex(node?: NodeInfo): number {
//   const index = node?.nodes?.findIndex(n => n.tagType === 'block');
//   return index as number;
// }
