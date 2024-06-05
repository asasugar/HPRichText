import { BorderStyle, Color, FontStyle, TextAlign, TextDecorationType, TextOverflow, Visibility } from './artUIEnum';

export type AttrsMap = Record<string, string | Record<string, string[]>>;


export interface AttrEnums {
  'border': {
    style: {
      solid: BorderStyle;
      dashed: BorderStyle;
      dotted: BorderStyle;
    };
  };
  'decoration': {
    type: {
      underline: TextDecorationType;
      'line-through': TextDecorationType;
      overline: TextDecorationType;
      none: TextDecorationType;
    };
  };
  'textAlign': {
    left: TextAlign;
    center: TextAlign;
    right: TextAlign;
  };
  'textOverflow': {
    overflow: {
      ellipsis: TextOverflow;
      clip: TextOverflow;
      none: TextOverflow;
    };
  };
}

export interface HeadingStyle {
  [x: string]: {
    fontWeight: number | string;
    fontSize: number | string;
    fontColor: string;
    margin: {
      top: number;
      bottom: number;
    };
  };
}

export interface SpecialStyles {
  b: {
    fontWeight: number | string;
    fontColor: string;
  };
  strong: {
    fontWeight: number | string;
    fontColor: string;
  };
  p: {
    fontSize: number | string;
    fontColor: string;
    margin: {
      top: number;
      bottom: number;
    };
  };
  div: {
    fontSize: number | string;
    fontColor: string;
  };
  i: {
    fontStyle: FontStyle;
    fontColor: string;
  };
  cite: {
    fontStyle: FontStyle;
    fontColor: string;
  };
  em: {
    fontStyle: FontStyle;
    fontColor: string;
  };
  var: {
    fontStyle: FontStyle;
    fontColor: string;
  };
  address: {
    fontStyle: FontStyle;
    fontColor: string;
  };
  pre: {
    fontFamily: string;
    fontColor: string;
    backgroundColor: string;
    padding: number;
    margin: {};
  };
  code: {
    fontFamily: string;
    fontColor: string;
    backgroundColor: string;
  };
  tt: {
    fontFamily: string;
    fontColor: string;
  };
  kbd: {
    fontFamily: string;
    fontColor: string;
  };
  samp: {
    fontFamily: string;
    fontColor: string;
  };
  big: {
    fontSize: number | string;
    fontColor: string;
  };
  small: {
    fontSize: number | string;
    fontColor: string;
  };
  sub: {
    fontSize: number | string;
    fontColor: string;
    // offset?: {
    //   x?: number
    //   y?: number;
    // };
  };
  sup: {
    fontSize: number | string;
    fontColor: string;
    // offset?: {
    //   x?: number
    //   y?: number;
    // };
  };
  s: {
    decoration: { type: TextDecorationType; };
    fontColor: string;
  };
  strike: {
    decoration: { type: TextDecorationType; };
    fontColor: string;
  };
  del: {
    decoration: { type: TextDecorationType; };
    fontColor: string;
  };
  a: {
    fontColor: Color;
    decoration: {
      type: TextDecorationType;
      color: Color;
    };
  };
  video: {
    textAlign: TextAlign;
    fontColor: string;
    margin: {
      top: number;
      bottom: number;
    };
  };
  blockquote: {
    fontColor: string;
    margin: {
      top: number;
      bottom: number;
    };
    padding: {
      top: number;
      bottom: number;
      left: number;
    };
  };
  ol: {
    fontColor: string;
    margin: {
      top: number;
      bottom: number;
    };
    padding: { left: number; };
  };
  ul: {
    fontColor: string;
    margin: {
      top: number;
      bottom: number;
    };
    padding: { left: number; };
  };
  u: {
    decoration: { type: TextDecorationType; };
    fontColor: string;
  };
  hide: {
    visibility: Visibility;
    fontColor: string;
  };
  input: {
    fontSize: number | string;
    fontColor: string;
  };
  textarea: {
    fontSize: number | string;
    fontColor: string;
  };
}