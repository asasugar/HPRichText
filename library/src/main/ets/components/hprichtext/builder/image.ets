import type { Attr, NodeInfo } from '../../../common/types';
import { resolveImageConstraintSize } from '../../../common/utils/imageConstraintSize';
import type { FancyImageOptions, LinkPressMethod, RichTextOption } from '../index';
import { _commonClick } from '../common';

@Builder
export function imageBuilder(item: NodeInfo, onLinkPress?: LinkPressMethod, richTextOption?: RichTextOption) {
  Image(item.attr?.resource ? $r(item.attr?.src) : item.attr?.src)
    .fancyImage(item?.artUIStyleObject,
      item?.attr)
    // maxWidth-only by default so objectFit=Contain can honor intrinsic height (#113).
    // Caller-provided imageProp.constraintSize is applied only for keys they set.
    .constraintSize(resolveImageConstraintSize(richTextOption?.imageProp?.constraintSize))
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
