/**
 * HPRichText: https://github.com/asasugar/HPRichText
 * @Author: asasugar<xxj95719@gmail.com>
 * 在@ComponentV2装饰的自定义组件中，开发者仅可以使用全新的状态变量装饰器，包括@Local、@Param、@Once、@Event、@Provider、@Consumer等。
 * @ComponentV2装饰的自定义组件暂不支持组件复用、LocalStorage等现有自定义组件的能力。
 * 无法同时使用@ComponentV2与@Component装饰同一个struct结构。
 * @ComponentV2支持一个可选的boolean类型参数freezeWhenInactive，来实现组件冻结功能。
 */
import type { Attr, HtmlParserResult, NodeInfo } from '../../common/types/htmlParser';
import type {
  FancyImageOptions,
  FancySpanOptions,
  FancyTextAreaOptions,
  FancyTextInputOptions,
  FancyTextOptions,
  FancyVideoOptions,
  LinkPressParame,
  NodesBuilderOptions,
  TextBuilderOptions
} from './index';
import HTMLParser from '../../common/utils/html/html-parser';
import { assign } from '../../common/utils/helperful';
import { RichTextOptionModelV2 } from './model/RichTextOptionModelV2';

@ComponentV2
export struct HPRichTextV2 {
  @Param
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();
  @Local
  defaultArtUI: FancySpanOptions = {};

  @Computed
  get htmlJson(): HtmlParserResult {
    const htmlParser = new HTMLParser(this.richTextModel.richTextOption);
    this.defaultArtUI = this._setDefaultArtUI(); // 生成默认样式
    const htmlJson = htmlParser.html2json();
    // console.log('转化之后的html', JSON.stringify?.(htmlJson.nodes));
    return htmlJson;
  };

  /**
   * @description: 生成默认样式为push的子节点添加默认样式
   * @returns {*}
   */
  _setDefaultArtUI() {
    return {
      fontSize: `${parseInt(String(this.richTextModel.richTextOption?.baseFontSize), 10) *
        (this.richTextModel.richTextOption?.basePixelRatio as number ??
          1)}${this.richTextModel.richTextOption?.basePixelUnit ??
        'vp'}`,
      fontColor: this.richTextModel.richTextOption?.baseFontColor ?? '#000000'
    } as FancySpanOptions
  }

  _commonClick(node: NodeInfo, event: ClickEvent, other: LinkPressParame) {
    if (!node?.attr?.onClick) {
      return;
    }
    // 增加回调事件
    try {
      this.richTextModel.onLinkPress?.(assign(other, {
        eventFnName: node?.attr?.onClick,
        clickEvent: event
      }));
    } catch (error) {
      console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
    }
  }

  /**
   * @description: Span文本样式构造器
   * @returns {*}
   */
  @Builder
  textBuilder($$: TextBuilderOptions) {
    Span($$.node.text)
      .fancySpan($$.node?.artUIStyleObject ||
        (!$$.parentNode?.isInlinePushNode || ($$.parentNode?.isInlinePushNode && $$.index === 0) ?
          $$.parentNode?.artUIStyleObject : this.defaultArtUI)
      )
      .onClick((event) => {
        // 不触发点击事件的场景：
        // 判断父级是否为isInlinePushNode的结构：
        // 是：
        // a. index!==0
        // b. 非<a>标签判断不存在onClick属性
        //
        // 否：
        // 非<a>标签判断不存在onClick属性

        // 检查是否为内联推送节点
        if ($$.parentNode?.isInlinePushNode) {
          // 对于内联推送节点，检查索引和父节点类型
          if ($$.index !== 0 || ($$.parentNode?.tag !== 'a' && !$$.parentNode?.attr?.onClick)
          ) {
            return;
          }
        } else {
          // 对于非内联推送节点，检查父节点类型
          if ($$.parentNode?.tag !== 'a' && !$$.parentNode?.attr?.onClick) {
            return
          }
        }
        if (($$.parentNode?.tag !== 'a' && !$$.parentNode?.attr?.onClick) ||
          ($$.parentNode?.tag === 'a' && $$.parentNode?.isInlinePushNode && $$.index !== 0)) {
          return;
        }
        // 增加回调事件
        try {
          this.richTextModel.onLinkPress?.({
            text: $$.node.text,
            link: $$.parentNode?.attr?.href,
            eventFnName: $$.parentNode?.attr?.onClick,
            clickEvent: event
          });
        } catch (error) {
          console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
        }
      })
  }

  /**
   * @description: 节点构造器函数
   * @returns {*}
   */
  @Builder
  nodesBuilder($$: NodesBuilderOptions) {
    if ($$.nodes?.length) {
      ForEach($$.nodes, (item: NodeInfo, i: number) => {
        // 标签
        if (item.node === 'element') {
          // video
          if (item.tag === 'video') {
            Video({
              src: item.attr?.src
            })
              .fancyVideo(item?.artUIStyleObject, item?.attr)
              .onClick((event) => {
                this._commonClick(item, event, { resourceSrc: item.attr?.src })
              });
          } else if (item.tag === 'img') {
            // img
            Image(item.attr?.src)
              .fancyImage(item?.artUIStyleObject, item?.attr)
              .onClick((event) => {
                this._commonClick(item, event, { resourceSrc: item.attr?.src })
              });
          } else if (item.tag === 'input') {
            TextInput({ text: item?.attr?.value, placeholder: item?.attr?.placeholder })
              .fancyTextInput(item?.artUIStyleObject, item?.attr);
          } else if (item.tag === 'textarea') {
            TextArea({
              placeholder: item?.attr?.placeholder,
              text: item?.nodes?.[0]?.text
            })
              .fancyTextArea(item?.artUIStyleObject);
          } else if (item.nodes?.length) {
            if (item.addHarmonyTextTag && !$$.parentNode?.addHarmonyTextTag) {
              Text() {
                this.nodesBuilder({
                  nodes: item.nodes,
                  parentNode: item,
                  alreadyAddText: true // 避免重复添加Text标签，导致敲套 Text 造成渲染失效问题
                })
              }
              .fancyText(item?.artUIStyleObject)
            } else {
              this.nodesBuilder({
                nodes: item.nodes,
                parentNode: item,
                alreadyAddText: $$.alreadyAddText
              })
            }
          }
        } else if (item.node === 'text') {
          // 兜底如果无标签包裹的纯文本渲染,样式需要继承上一个同级节点样式
          if (!$$.alreadyAddText &&
            (!$$.parentNode || (!$$.parentNode.addHarmonyTextTag && !$$.parentNode.isInlinePushNode))) {
            Text() {
              this.textBuilder({ node: item, index: i, parentNode: $$.parentNode });
            }
            .fancyText(item?.artUIStyleObject || $$.parentNode?.artUIStyleObject)
          } else {
            this.textBuilder({ node: item, index: i, parentNode: $$.parentNode });
          }
        }
      }, (item: NodeInfo, index: number) => Math.random().toFixed(3) + item.node + item.tag + item.tagType + index)
    }
  }

  build() {
    if (this.richTextModel.needScroll) {
      Scroll() {
        Column() {
          this.nodesBuilder({ nodes: this.htmlJson.nodes });
        }
        .alignItems(HorizontalAlign?.Start)
      }
    } else {
      Column() {
        this.nodesBuilder({ nodes: this.htmlJson.nodes });
      }
      .alignItems(HorizontalAlign?.Start)
    }
  }
}


@Extend(Span)
function fancySpan($$: FancySpanOptions = {}) {
  .fontColor($$.fontColor)
  .fontSize($$.fontSize)
  .fontStyle($$.fontStyle)
  .fontWeight($$.fontWeight)
  .fontFamily($$.fontFamily)
  .letterSpacing($$.letterSpacing)
  .decoration($$.decoration ?? { type: TextDecorationType.None }) // 避免push到子节点的时候，继承 Text 的属性
}

@Extend(Text)
function fancyText($$: FancyTextOptions = {}) {
  .width($$.width ?? '100%') // 默认设置 Text 长度100%
  .height($$.height)
  .margin($$.margin)
  .padding($$.padding)
  .zIndex($$.zIndex)
  .opacity($$.opacity)
  .backgroundColor($$.backgroundColor)
  .backgroundImage($$.backgroundImage)
  .rotate($$.rotate)
  .scale($$.scale)
  // .offset($$.offset)
  .decoration($$.decoration)
  .lineHeight($$.lineHeight)
  .letterSpacing($$.letterSpacing)
  .fontColor($$.fontColor)
  .fontSize($$.fontSize)
  .fontWeight($$.fontWeight)
  .fontFamily($$.fontFamily)
  .textAlign($$.textAlign)
  .textOverflow($$.textOverflow)
  .maxLines($$.maxLines ? Number($$.maxLines) : $$.textOverflow ? 1 : null)
  .border($$.border)
}

@Extend(Image)
function fancyImage($$: FancyImageOptions = {}, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .margin($$.margin)
  .padding($$.padding)
  .alt(attrs.alt)
  .opacity($$.opacity)
  .objectFit($$.objectFit)
}


@Extend(Video)
function fancyVideo($$: FancyVideoOptions = {}, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .muted(attrs.muted)
  .autoPlay(attrs.autoplay)
  .loop(attrs.loop)
  .controls(true) // 默认为非自定义控制器
  .objectFit(ImageFit.Contain)
}


@Extend(TextInput)
function fancyTextInput($$: FancyTextInputOptions = { fontSize: 14, fontColor: Color.Black }, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .type(
    attrs.type === 'number' ? InputType?.Number :
      attrs.type === 'tel' ? InputType?.PhoneNumber :
        attrs.type === 'password' ? InputType?.Password :
          attrs.type === 'email' ? InputType?.Email :
            InputType?.Normal
  )
  .placeholderColor(Color?.Grey)
  .placeholderFont({ size: 14, weight: 400 })
  .fontSize($$.fontSize)
  .fontColor($$.fontColor)
  .maxLength(attrs.maxlength)
  .inputFilter(attrs.pattern, (e) => {
    // console.log(JSON.stringify(e))
  })
}

@Extend(TextArea)
function fancyTextArea($$: FancyTextAreaOptions = {}) {
  .width($$.width)
  .height($$.height)
  .placeholderFont({ size: 16, weight: 400 })
  .fontSize($$.fontSize)
  .fontColor($$.fontColor)
  .backgroundColor($$.backgroundColor)
}