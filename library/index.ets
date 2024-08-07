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
import HTMLParser from './src/main/ets/common/utils/html/html-parser';

// 导出ts声明
// 不支持 export * from 'xx'
export type {
  RichTextOption,
  TextBuilderOptions,
  NodesBuilderOptions,
  FancySpanOptions,
  FancyTextOptions,
  FancyImageOptions,
  FancyVideoOptions,
  FancyTextInputOptions,
  FancyTextAreaOptions,
  PixelUnit,
  LinkPressParame,
  LinkPressMethod,
  Attribute,
  SimpleNode,
  NodeInfo,
  ImageProp,
  CustomHandler,
  HtmlParserResult,
  Attr,
  StyleObject,
  ArtStyleObject,
  AttrsMap,
  AttrEnums,
  HeadingStyle,
  SpecialStyles,
  Nullable
};

// 导出组件
export { HPRichText } from './src/main/ets/components/hprichtext/HPRichText';

// 导出方法
export { HTMLParser };
