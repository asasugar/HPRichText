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

/// 参数
export interface ZZRichTextOptionModelParam {
  richTextOption?: RichTextOption
  needScroll?: boolean
  copyEnable?: boolean
  onLinkPress?: LinkPressMethod;
  onCopyPress?: CopyPressMethod;
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
  // 是否开启Text的copy功能，默认为false
  @Trace
  copyEnable: boolean = false;

  onLinkPress?: LinkPressMethod;
  onCopyPress?: CopyPressMethod;

  //方便外面初始化用
  constructor(param?: ZZRichTextOptionModelParam) {
    this.richTextOption = param?.richTextOption ?? { content: '' }
    this.needScroll = param?.needScroll ?? true
    this.copyEnable = param?.copyEnable ?? false
    this.onLinkPress = param?.onLinkPress
    this.onCopyPress = param?.onCopyPress
  }
}
