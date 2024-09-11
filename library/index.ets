import type {
  ArtStyleObject,
  Attr,
  AttrEnums,
  Attribute,
  AttrsMap,
  CustomHandler,
  HeadingStyle,
  HtmlParserResult,
  ImageProp,
  NodeInfo,
  Nullable,
  SimpleNode,
  SpecialStyles,
  StyleObject
} from './src/main/ets/common/types';
import { excludeExtendsParentArtUIStyle, firstLetterToLowerCase, formatColor, headingStyles, parseStyle, parseToArtUI, setHtmlAttributes, specialStyles, transformObject } from './src/main/ets/common/utils/css/index';
import HTMLParser from './src/main/ets/common/utils/html/html-parser';
import type {
  FancyImageOptions,
  FancySpanOptions,
  FancyTextAreaOptions,
  FancyTextInputOptions,
  FancyTextOptions,
  FancyVideoOptions,
  LinkPressMethod,
  LinkPressParame,
  NodesBuilderOptions,
  PixelUnit,
  RichTextOption,
  TextBuilderOptions
} from './src/main/ets/components/hprichtext/index';
// 导出ts声明
// 不支持 export * from 'xx'
export type {
  ArtStyleObject, Attr, AttrEnums, Attribute, AttrsMap, CustomHandler, FancyImageOptions, FancySpanOptions, FancyTextAreaOptions, FancyTextInputOptions, FancyTextOptions, FancyVideoOptions, HeadingStyle, HtmlParserResult, ImageProp, LinkPressMethod, LinkPressParame, NodeInfo, NodesBuilderOptions, Nullable, PixelUnit, RichTextOption, SimpleNode, SpecialStyles, StyleObject, TextBuilderOptions
};

// 导出组件
  export { HPRichText } from './src/main/ets/components/hprichtext/HPRichText';

// 导出方法
export { excludeExtendsParentArtUIStyle, firstLetterToLowerCase, formatColor, headingStyles, HTMLParser, parseStyle, parseToArtUI, setHtmlAttributes, specialStyles, transformObject };
