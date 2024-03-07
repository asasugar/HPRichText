export interface Attribute {
  name: string;
  value: string;
  escaped: string;
}

export interface ScreenInfo {
  width: number;
  height: number;
}

export interface TextNode {
  node: 'text';
  text?: string;
}

export interface NodeInfo {
  node?: 'element' | 'text';
  tag?: string;
  $screen?: {
    width: number;
    height: number;
  };
  tagType?: 'block' | 'inline' | 'closeSelf';
  attr?: Attr;
  artUIStyleObject?: Record<string, any>;
  text?: string;
  nodes?: NodeInfo[];
}

export interface HtmlParserResult extends NodeInfo {
  imageUrls?: string[];
  text?: string;
  source?: string
}

interface Attr extends Record<string, any> {
  src?: string;
  alt?: string;
  style?: string | StyleObject;
  poster?: string;
  width?: string | number;
  height?: string | number;
  muted?: boolean;
  autoplay?: boolean;
  controls?: boolean;
  loop?: boolean;
}

export interface StyleObject {
  'flex-basis'?: string | number;
  'flex-grow'?: number;
  'flex-shrink'?: number;
  'align-self'?: 'auto' | 'normal' | 'self-start' | 'self-end' | 'flex-start' | 'flex-end' | 'center' | 'baseline' | 'first' | 'baseline' | 'last' | 'baseline' | 'safe' | 'unsafe'
  'width'?: string | number;
  'height'?: string | number;
  'margin'?: string;
  'padding'?: string;
  'z-index'?: number;
  'border'?: string;
  'border-style'?: 'none' | 'dotted' | 'inset' | 'dashed' | 'hidden' | 'solid' | 'double' | 'groove' | 'outset'
  'border-width'?: string;
  'border-color'?: string;
  'border-radius'?: string;
  'opacity'?: number;
  'background-color'?: string;
  'background-image'?: string;
  'background-repeat'?: string;
  'background-size'?: string;
  'background-position'?: string;
  'rotate'?: string;
  'scale'?: string;
  'translate'?: string;
  'transform'?: string;
  'visibility'?: 'visible' | 'hidden' | 'collapse';
  // 'position':'position',
  // 'shadow':'shadow',
  'offset'?: string;
  'text-decoration'?: string;
  'line-height'?: string;
  'letter-spacing'?: string;
  // 'line-height':'maxLines',
  'color'?: string;
  'font-size'?: string;
  'font-style'?: string;
  'font-weight'?: number;
  'font-family'?: string;
  // 'text-overflow'?: string;
  'text-align'?: 'start' | 'end' | 'center' | 'justify';
}
