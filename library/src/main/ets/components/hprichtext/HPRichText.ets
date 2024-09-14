/**
 * HPRichText: https://github.com/asasugar/HPRichText
 * @Author: asasugar<xxj95719@gmail.com>
 */
import type { Nullable } from '../../common/types/common';
import type { Attr, HtmlParserResult, NodeInfo } from '../../common/types/htmlParser';
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
  RichTextOption,
  TextBuilderOptions
} from './index';
import HTMLParser from '../../common/utils/html/html-parser';
import { assign } from '../../common/utils/helperful';

@Component
export struct HPRichText {
  @Link @Watch('onUpdateRichTextOption') richTextOption: RichTextOption;
  @Prop needScroll: boolean;
  onLinkPress: Nullable<LinkPressMethod> = null;
  @State htmlJson: HtmlParserResult = {
    nodes: []
  };
  @State defaultArtUI: FancySpanOptions = {};

  // getBlockIndex(node?: NodeInfo): number {
  //   const index = node?.nodes?.findIndex(n => n.tagType === 'block');
  //   return index as number;
  // }

  /**
   * @description: 生成默认样式为push的子节点添加默认样式
   * @returns {*}
   */
  _setDefaultArtUI() {
    return {
      fontSize: `${parseInt(String(this.richTextOption.baseFontSize), 10) *
        (this.richTextOption.basePixelRatio as number ?? 1)}${this.richTextOption.basePixelUnit ?? 'vp'}`,
      fontColor: this.richTextOption.baseFontColor ?? '#000000'
    } as FancySpanOptions
  }

  /**
   * @description: 公共点击事件处理
   * @returns {*}
   */
  _commonClick(node: NodeInfo, event: ClickEvent, other: LinkPressParame) {
    if (!node?.attr?.onClick) {
      return;
    }
    // 增加回调事件
    try {
      this.onLinkPress?.(assign(other, {
        eventFnName: node?.attr?.onClick,
        clickEvent: event
      }));
    } catch (error) {
      console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
    }
  }

  /**
   * @description: 判断是否需要包裹 Text 标签
   * @returns {*}
   */
  _isNeedRenderText($$: NodesBuilderOptions) {
    const parentCanAddText = $$.parentNode?.addHarmonyTextTag;
    return !$$.alreadyAddText && (!$$.parentNode || !parentCanAddText);
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
          this.onLinkPress?.({
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
          if (this._isNeedRenderText($$)) {
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

  // 监听到richTextOption参数变化则重新触发 HTML转化函数
  onUpdateRichTextOption() {
    const htmlParser = new HTMLParser(this.richTextOption);
    this.defaultArtUI = this._setDefaultArtUI(); // 生成默认样式
    this.htmlJson = htmlParser.html2json();
    // console.log('转化之后的html', JSON.stringify?.(this.htmlJson.nodes));
  }

  // 初始化更新
  aboutToAppear() {
    if (this.richTextOption.content) {
      this.onUpdateRichTextOption();
    }
  }

  build() {
    if (this.needScroll) {
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