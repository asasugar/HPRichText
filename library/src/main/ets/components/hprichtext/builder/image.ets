import type { Attr, NodeInfo } from '../../../common/types';
import type { FancyImageOptions, LinkPressMethod, RichTextOption } from '../index';
import { _commonClick } from '../common';

@Builder
export function imageBuilder(item: NodeInfo, onLinkPress?: LinkPressMethod, richTextOption?: RichTextOption) {
  Image(item.attr?.resource ? $r(item.attr?.src) : item.attr?.src)
    .fancyImage(item?.artUIStyleObject,
      item?.attr)
    .copyOption(richTextOption?.imageProp?.copyEnable ? CopyOptions.InApp : CopyOptions.None)
    .onClick((event) => {
      _commonClick(item, event, { resourceSrc: item.attr?.src }, onLinkPress)
    });
}

@Extend(Image)
function fancyImage($$: FancyImageOptions = {}, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .margin($$.margin)
  .padding($$.padding)
  .alt(attrs.alt)
  .opacity($$.opacity)
  .objectFit($$.objectFit)
}
