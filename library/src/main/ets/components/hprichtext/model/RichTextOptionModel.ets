import type { CustomHandler, ImageProp } from '../../../common/types';
import type { PixelUnit } from '../index';

@Observed
export class RichTextOptionModel {
  content: string = '';
  baseFontSize?: number | Resource;
  baseFontColor?: string | Resource;
  basePixelUnit?: PixelUnit;
  basePixelRatio?: number | Resource;
  imageProp?: ImageProp;
  customHandler?: CustomHandler;
}