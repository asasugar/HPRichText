import type { CustomHandler, ImageProp } from '../../../common/types';
import type { CopyPressMethod, LinkPressMethod, PixelUnit } from '../index';

export class RichTextOption {
  content: string = '';
  baseFontSize?: number | Resource;
  baseFontColor?: string | Resource;
  basePixelUnit?: PixelUnit;
  basePixelRatio?: number | Resource;
  imageProp?: ImageProp;
  customHandler?: CustomHandler;
}


@ObservedV2
export class RichTextOptionModelV2 {
  // richTextOption变化时自动刷新组件
  @Trace
  richTextOption: RichTextOption = {
    content: '',
  }
  // needScroll变化时自动刷新组件
  @Trace
  needScroll?: boolean = true;
  // scrollBar变化时自动刷新组件，默认 Auto（滚动时显示滚动条）
  @Trace
  scrollBar?: BarState = BarState.Auto;
  // 是否开启Text的copy功能，默认为false
  @Trace
  copyEnable: boolean = false;
  onLinkPress?: LinkPressMethod;
  onCopyPress?: CopyPressMethod;
}
