import type { FontAttr, PositionAttr, Resource, ResourceColor, ShapeAttr, } from '../../common/types/artUIBase';
import { Color } from '../../common/types/artUIEnum';

import type { CustomHandler, ImageProp, NodeInfo } from '../../common/types/htmlParser';


export interface TextBuilderOptions {
  node: NodeInfo;
  index: number;
  parentNode?: NodeInfo;
}


export interface NodesBuilderOptions {
  nodes?: NodeInfo[];
  parentNode?: NodeInfo;
  alreadyAddText?: boolean;
}

export interface FancySpanOptions extends FontAttr {

  decoration?: {
    type: 0 | 1 | 2 | 3;
    color?: ResourceColor;
  };
  letterSpacing?: string;
}

export interface FancyContainerSpanOptions {
  backgroundColor?: Color | number | string | ResourceColor;
  borderRadius?: string;
}

export interface FancyTextOptions extends FontAttr, ShapeAttr, PositionAttr {
  zIndex?: number;
  opacity?: number;
  backgroundColor?: ResourceColor;
  backgroundImage?: string;
  decoration?: {
    type: 0 | 1 | 2 | 3;
    color?: ResourceColor;
  };
  lineHeight?: string | number;
  letterSpacing?: string;
  textAlign?: 0 | 1 | 2 | 3;
  textOverflow?: {
    overflow: 0 | 1 | 2 | 3;
  };
  maxLines?: number;
  border?: {
    width?: string | number;
    style?: 0 | 1 | 2;
    color?: Color | string;
    radius?: string;
  }
}

export interface FancyImageOptions extends ShapeAttr {
  opacity?: number;
  objectFit?: 0 | 1 | 2 | 3 | 4 | 5;
}

export interface FancyVideoOptions {
  width?: string | number;
  height?: string | number;
}

export interface FancyTextInputOptions {
  width?: string | number;
  height?: string | number;
  fontSize?: string | number;
  fontColor?: ResourceColor;
}

export interface FancyTextAreaOptions {
  width?: string | number;
  height?: string | number;
  fontSize?: string | number;
  fontColor?: Color;
  backgroundColor?: Color | number | string | ResourceColor;
}

export type PixelUnit = 'vp' | 'px' | 'fp' | 'lpx';


export interface RichTextOption {
  content: string;
  baseFontSize?: number | Resource;
  baseFontColor?: string | Resource;
  basePixelUnit?: PixelUnit;
  basePixelRatio?: number | Resource;
  imageProp?: ImageProp;
  customHandler?: CustomHandler;
}

export interface LinkPressParame {
  text?: string;
  resourceSrc?: string;
  link?: string;
  clickEvent?: { [x: string]: any };
  eventFnName?: string;
}

export interface LinkPressMethod<T = LinkPressParame> {
  (arg: T): T | void
}

export interface CopyPressParame {
  text: string,
}

export interface CopyPressMethod<T = CopyPressParame> {
  (arg: T): T | void
}



export interface SpanBuilderInstall {
  defaultArtUI?: FancySpanOptions;
  onLinkPress?: LinkPressMethod
}