import { BorderStyle, Color, FontStyle, TextAlign, TextDecorationType, TextOverflow, Visibility } from './artUIEnum';

export type AttrsMap = Record<string, string | Record<string, string[]>>;

export interface BaseFontAttrs {
  fontColor: string;
  fontSize: number | string;
}

export interface BaseFontAttrsWithStyle extends BaseFontAttrs{
  fontStyle: FontStyle;
}

export interface BaseFontAttrsWithWeight extends BaseFontAttrs{
  fontWeight: number | string;
}

export interface BaseFontAttrsWithFamily extends BaseFontAttrs{
  fontFamily: string;
}

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
  b: BaseFontAttrsWithWeight;
  strong: BaseFontAttrsWithWeight;
  p: {
    margin: {
      top: number;
      bottom: number;
    };
  } & BaseFontAttrs;
  div: BaseFontAttrs;
  i: BaseFontAttrsWithStyle;
  cite: BaseFontAttrsWithStyle;
  em: BaseFontAttrsWithStyle;
  var: BaseFontAttrsWithStyle;
  address: BaseFontAttrsWithStyle;
  pre: {
    backgroundColor: string;
    padding: number;
    margin: {};
  } & BaseFontAttrsWithFamily;
  code: {
    backgroundColor: string;
  } & BaseFontAttrsWithFamily;
  tt: BaseFontAttrsWithFamily;
  kbd: BaseFontAttrsWithFamily;
  samp: BaseFontAttrsWithFamily;
  big: BaseFontAttrs;
  small: BaseFontAttrs;
  sub: BaseFontAttrs;
  sup: BaseFontAttrs;
  s: {
    decoration: { type: TextDecorationType; };
  } & BaseFontAttrs;
  strike: {
    decoration: { type: TextDecorationType; };
  } & BaseFontAttrs;
  del: {
    decoration: { type: TextDecorationType; };
  } & BaseFontAttrs;
  a: {
    decoration: {
      type: TextDecorationType;
      color: Color | string;
    };
  } & BaseFontAttrs;
  video: {
    textAlign: TextAlign;
    margin: {
      top: number;
      bottom: number;
    };
  } & BaseFontAttrs;
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
  } & BaseFontAttrs;
  ol: {
    margin: {
      top: number;
      bottom: number;
    };
    padding: { left: number; };
  } & BaseFontAttrs;
  ul: {
    margin: {
      top: number;
      bottom: number;
    };
    padding: { left: number; };
  } & BaseFontAttrs;
  u: {
    decoration: { type: TextDecorationType; };
  } & BaseFontAttrs;
  hide: {
    visibility: Visibility;
  } & BaseFontAttrs;
  input: BaseFontAttrs;
  textarea: BaseFontAttrs;
}