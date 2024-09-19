import type { CustomHandler, ImageProp } from '../../../common/types';
import type { LinkPressMethod, PixelUnit } from '../index';

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
  onLinkPress?: LinkPressMethod;
}
