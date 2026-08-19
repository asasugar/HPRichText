import { assign } from '../../../common/utils/helperful';
import { resolveLinkPress, shouldFireNodeClick } from '../../../common/utils/html/click';
import type { FancySpanOptions, SpanBuilderInstall, TextBuilderOptions } from '../index';
import type { StyleObject } from '../../../common/types';

function mergeFancySpan($$: TextBuilderOptions, install: SpanBuilderInstall) {
  const index = $$.index;
  let clickIndex: number = $$.parentNode?.attr?.clickIndex;
  const clickTag = $$.parentNode?.tag;
  const artUIStyleObject = $$.node?.artUIStyleObject || $$.parentNode?.artUIStyleObject || install.defaultArtUI;
  // 当存在a标签的点击时候，需要让除了 <a> 标签包括以外的内容继承外层字体颜色样式
  if (clickTag === 'a' && clickIndex !== undefined && index !== clickIndex) {
    const attrStyle = $$.parentNode?.attr?.style as StyleObject;
    const parentAttrStyleColor: string = attrStyle?.color ?? '';
    return assign({ fontColor: parentAttrStyleColor }, artUIStyleObject) as FancySpanOptions
  }
  return artUIStyleObject;
}

@Builder
export function spanBuilder($$: TextBuilderOptions, install: SpanBuilderInstall) {
  Span($$.node.text)
    .fancySpan(mergeFancySpan($$, install))
    .onClick((event) => {
      // Nested inline tags inherit parent <a> href / onClick (see inheritClickableAttrs)
      if (!shouldFireNodeClick($$.parentNode, $$.index)) {
        return;
      }
      // 增加回调事件
      try {
        install.onLinkPress?.(assign(resolveLinkPress($$.parentNode, $$.node.text), {
          clickEvent: event
        }));
      } catch (error) {
        console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
      }
    })
}

@Extend(Span)
function fancySpan($$: FancySpanOptions = {}) {
  .fontColor($$.fontColor)
  .fontSize($$.fontSize)
  .fontStyle($$.fontStyle)
  .fontWeight($$.fontWeight)
  .fontFamily($$.fontFamily)
  .letterSpacing($$.letterSpacing)
  .decoration($$.decoration ?? { type: TextDecorationType.None }) // 避免push到子节点的时候，继承 Text 的属性
}
