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
    fontSize: number;
    margin: {
      top: number;
      bottom: number;
    };
  };
}

export interface P {
  margin: {
    top: number;
    bottom: number;
  }
}

export interface SpecialStyles {
  b: { fontWeight: number | string; };
  strong: { fontWeight: number | string; };
  p: {
    fontSize: number;
    margin: {
      top: number;
      bottom: number;
    };
  };
  i: { fontStyle: FontStyle; };
  cite: { fontStyle: FontStyle; };
  em: { fontStyle: FontStyle; };
  var: { fontStyle: FontStyle; };
  address: { fontStyle: FontStyle; };
  pre: {
    fontFamily: string;
    backgroundColor: string;
    padding: number;
    margin: {};
  };
  code: {
    fontFamily: string;
    backgroundColor: string;
  };
  tt: { fontFamily: string; };
  kbd: { fontFamily: string; };
  samp: { fontFamily: string; };
  big: { fontSize: number; };
  small: { fontSize: number; };
  sub: {
    fontSize: number;
    offset: { y: number; };
  };
  sup: {
    fontSize: number;
    offset: { y: number; };
  };
  s: { decoration: { type: TextDecorationType; }; };
  strike: { decoration: { type: TextDecorationType; }; };
  del: { decoration: { type: TextDecorationType; }; };
  a: {
    fontColor: Color;
    decoration: {
      type: TextDecorationType;
      color: Color;
    };
  };
  video: {
    textAlign: TextAlign;
    margin: {
      top: number;
      bottom: number;
    };
  };
  blockquote: {
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
    margin: {
      top: number;
      bottom: number;
    };
    padding: { left: number; };
  };
  ul: {
    margin: {
      top: number;
      bottom: number;
    };
    padding: { left: number; };
  };
  u: { decoration: { type: TextDecorationType; }; };
  hide: { visibility: Visibility; };
}