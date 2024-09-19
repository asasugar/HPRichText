import type { Attr, NodeInfo } from '../../../common/types';
import type { FancyVideoOptions, LinkPressMethod } from '../index';
import { _commonClick } from '../common';

@Builder
export function videoBuilder(item: NodeInfo, onLinkPress?: LinkPressMethod) {
  Video({
    src: item.attr?.src
  })
    .fancyVideo(item?.artUIStyleObject, item?.attr)
    .onClick((event) => {
      _commonClick(item, event, { resourceSrc: item.attr?.src }, onLinkPress)
    });
}

@Extend(Video)
function fancyVideo($$: FancyVideoOptions = {}, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .muted(attrs.muted)
  .autoPlay(attrs.autoplay)
  .loop(attrs.loop)
  .controls(true) // 默认为非自定义控制器
  .objectFit(ImageFit.Contain)
}
