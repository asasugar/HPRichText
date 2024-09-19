import type { Attr, NodeInfo } from '../../../common/types';
import type { FancyImageOptions, LinkPressMethod } from '../index';
import { _commonClick } from '../common';

@Builder
export function imageBuilder(item: NodeInfo, onLinkPress?: LinkPressMethod) {
  Image(item.attr?.src)
    .fancyImage(item?.artUIStyleObject, item?.attr)
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
