import { Color, FontWeight } from './artUIEnum';

export type ResourceColor = Color | number | string;

export interface FontAttr {
  fontColor?: Color;
  fontSize?: string | number;
  fontStyle?: 0 | 1;
  fontWeight?: FontWeight;
  fontFamily?: string;
}

export interface ShapeAttr {
  width?: string | number;
  height?: string | number;
  margin?: {
    top?: string | number;
    bottom?: string | number;
    left?: string | number;
    right?: string | number;
  }
  padding?: {
    top?: string | number;
    bottom?: string | number;
    left?: string | number;
    right?: string | number;
  }
}

export interface PositionAttr {
  rotate?: {
    x?: number;
    y?: number;
    z?: number;
    centerX?: number | string;
    centerY?: number | string;
    centerZ?: number;
    perspective?: number;
    angle: number | string;
  };
  scale?: {
    x?: number;
    y?: number;
    z?: number;
    centerX?: number | string;
    centerY?: number | string;
  };
  // offset?: {
  //   x: number;
  //   y: number
  // };
}

export interface OtherAttr {
  border?: {
    width?: string | number;
    style?: 0 | 1 | 2;
    color?: Color | string;
    radius?: string;
  };
  zIndex?: number;
  opacity?: number;
  backgroundColor?: Color | string;
  backgroundImage?: string;
  decoration?: {
    type: 0 | 1 | 2 | 3;
    color?: Color | string;
  };
  lineHeight?: string;
  letterSpacing?: string;
  textAlign?: 0 | 1 | 2 | 3;
}
