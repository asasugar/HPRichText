import type { NodeInfo } from '../../../common/types';
import type { FancyTextAreaOptions } from '../index';

@Builder
export function textAreaBuilder(item: NodeInfo) {
  TextArea({
    placeholder: item?.attr?.placeholder,
    text: item?.nodes?.[0]?.text
  })
    .fancyTextArea(item?.artUIStyleObject);
}

@Extend(TextArea)
function fancyTextArea($$: FancyTextAreaOptions = {}) {
  .width($$.width)
  .height($$.height)
  .placeholderFont({ size: 16, weight: 400 })
  .fontSize($$.fontSize)
  .fontColor($$.fontColor)
  .backgroundColor($$.backgroundColor)
}