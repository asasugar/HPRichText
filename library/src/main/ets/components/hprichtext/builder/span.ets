import type { FancySpanOptions, SpanBuilderInstall, TextBuilderOptions } from '../index';

@Builder
export function spanBuilder($$: TextBuilderOptions, install: SpanBuilderInstall) {
  Span($$.node.text)
    .fancySpan($$.node?.artUIStyleObject || $$.parentNode?.artUIStyleObject || install.defaultArtUI)
    .onClick((event) => {
      // 不触发点击事件的场景：
      // 判断父级是否为isInlinePushNode的结构：
      // 是：
      // a. index!==0
      // b. 非<a>标签判断不存在onClick属性
      //
      // 否：
      // 非<a>标签判断不存在onClick属性

      // 检查是否为内联推送节点
      if ($$.parentNode?.isInlinePushNode) {
        // 对于内联推送节点，检查索引和父节点类型
        if ($$.index !== 0 || ($$.parentNode?.tag !== 'a' && !$$.parentNode?.attr?.onClick)
        ) {
          return;
        }
      } else {
        // 对于非内联推送节点，检查父节点类型
        if ($$.parentNode?.tag !== 'a' && !$$.parentNode?.attr?.onClick) {
          return
        }
      }
      if (($$.parentNode?.tag !== 'a' && !$$.parentNode?.attr?.onClick) ||
        ($$.parentNode?.tag === 'a' && $$.parentNode?.isInlinePushNode && $$.index !== 0)) {
        return;
      }
      // 增加回调事件
      try {
        install.onLinkPress?.({
          text: $$.node.text,
          link: $$.parentNode?.attr?.href,
          eventFnName: $$.parentNode?.attr?.onClick,
          clickEvent: event
        });
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
