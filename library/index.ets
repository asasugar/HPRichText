import HTMLParser from './src/main/ets/common/utils/html/html-parser';

// 导出ts声明
// 不支持 export * from 'xx'
export type {
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

export type {
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

// 导出组件
export { HPRichText } from './src/main/ets/components/hprichtext/HPRichText'; // v1基础组件

export { ObservedHPRichText } from './src/main/ets/components/hprichtext/ObservedHPRichText'; // v1 observed组件

export { HPRichTextV2 } from './src/main/ets/components/hprichtext/HPRichTextV2'; // v2组件

// 导出方法
export {
  excludeExtendsParentArtUIStyle,
  firstLetterToLowerCase,
  formatColor,
  headingStyles,
  parseStyle,
  parseToArtUI,
  setHtmlAttributes,
  specialStyles,
  transformObject
} from './src/main/ets/common/utils/css/index';

// 导出model
export { RichTextOptionModel } from './src/main/ets/components/hprichtext/model/RichTextOptionModel';

export { RichTextOptionModelV2 } from './src/main/ets/components/hprichtext/model/RichTextOptionModelV2';

export { HTMLParser };
