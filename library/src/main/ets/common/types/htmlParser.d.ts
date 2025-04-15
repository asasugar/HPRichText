import type { FontAttr, OtherAttr, PositionAttr, ShapeAttr } from './artUIBase';
import type { Nullable } from './common';

export interface Attribute {
  name: string;
  value: string;
  escaped: string;
}

export interface SimpleNode {
  node?: 'element' | 'text' | 'comment';
  text?: string;
  artUIStyleObject?: ArtStyleObject; // 用于继承父级样式
  isInlinePushNode?: boolean;
}

export interface NodeInfo extends SimpleNode {
  tag?: string;
  tagType?: 'block' | 'inline' | 'closeSelf';
  attr?: Attr;
  nodes?: NodeInfo[];
  addHarmonyTextTag?: boolean;
}

export interface ImageProp {
  objectFit?: 'Contain' | 'Cover' | 'Auto' | 'Fill' | 'ScaleDown' | 'None';
  margin?: number | string;
  webp?: boolean;
  copyEnable?: boolean;
}


export interface ALinkDecorationProp {
  /*a标签下划线的格式*/
  type?: 'None' | 'Underline' | 'Overline' | 'LineThrough';
  /*a标签下划线的颜色*/
  color?: string;
}


export interface ALinkProp {
  /*a标签链接的默认颜色*/
  linkColor?: string;
  /*a标签下划线的格式*/
  decoration?: ALinkDecorationProp
}

export interface CustomHandler {
  start: Function;
  end: Nullable<Function>;
  chars: Nullable<Function>;
}

// HtmlParser类的返回结果
export interface HtmlParserResult {
  source?: string;
  nodes: NodeInfo[];
}

// html字符串标签的属性
interface Attr extends Record<string, any> {
  src?: string;
  alt?: string;
  style?: Nullable<string | StyleObject>;
  poster?: string;
  width?: string | number;
  height?: string | number;
  muted?: boolean;
  autoplay?: boolean;
  controls?: boolean;
  loop?: boolean;
  type?: 'number' | 'password' | 'tel' | 'email';
  maxlength?: number;
  pattern?: string;
}

// html字符串传入的行内样式
export interface StyleObject {
  'width'?: string | number;
  'height'?: string | number;
  'margin'?: string;
  'padding'?: string;
  'z-index'?: number;
  'border'?: string;
  'border-style'?: string;
  'border-width'?: string;
  'border-color'?: string;
  'border-radius'?: string;
  'opacity'?: number;
  'background-color'?: string;
  'background-image'?: string;
  'background-size'?: string;
  'background-position'?: string;
  'rotate'?: string;
  'scale'?: string;
  'offset'?: string;
  'visibility'?: 'visible' | 'hidden' | 'collapse';
  'text-decoration'?: string;
  'line-height'?: string;
  'letter-spacing'?: string;
  'color'?: string;
  'font-size'?: string;
  'font-style'?: string;
  'font-weight'?: number;
  'font-family'?: string;
  'text-overflow'?: string;
  '-webkit-line-clamp'?: number;
  'text-align'?: 'start' | 'end' | 'center' | 'justify';
}


export interface ArtStyleObject extends FontAttr, ShapeAttr, PositionAttr, OtherAttr {}