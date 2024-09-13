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
  maxWidth?: string | number;
  maxHeight?: string | number;
  minWidth?: string | number;
  minHeight?: string | number;
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

export interface Resource {
  /**
   * bundle name in hap
   *
   * @type { string }
   * @syscap SystemCapability.Global.ResourceManager
   * @since 9
   */
  /**
   * bundle name in hap
   *
   * @type { string }
   * @syscap SystemCapability.Global.ResourceManager
   * @crossplatform
   * @atomicservice
   * @since 11
   */
  bundleName: string;

  /**
   * module name in hap
   *
   * @type { string }
   * @syscap SystemCapability.Global.ResourceManager
   * @since 9
   */
  /**
   * module name in hap
   *
   * @type { string }
   * @syscap SystemCapability.Global.ResourceManager
   * @crossplatform
   * @atomicservice
   * @since 11
   */
  moduleName: string;

  /**
   * resource id in hap
   *
   * @type { number }
   * @syscap SystemCapability.Global.ResourceManager
   * @since 9
   */
  /**
   * resource id in hap
   *
   * @type { number }
   * @syscap SystemCapability.Global.ResourceManager
   * @crossplatform
   * @atomicservice
   * @since 11
   */
  id: number;

  /**
   * Set params.
   *
   * @type { ?any[] }
   * @syscap SystemCapability.Global.ResourceManager
   * @since 7
   */
  /**
   * Set params.
   *
   * @type { ?any[] }
   * @syscap SystemCapability.Global.ResourceManager
   * @crossplatform
   * @atomicservice
   * @since 11
   */
  params?: any[];

  /**
   * Set type.
   *
   * @type { ?number }
   * @syscap SystemCapability.Global.ResourceManager
   * @since 7
   */
  /**
   * Set type.
   *
   * @type { ?number }
   * @syscap SystemCapability.Global.ResourceManager
   * @crossplatform
   * @atomicservice
   * @since 11
   */
  type?: number;
}