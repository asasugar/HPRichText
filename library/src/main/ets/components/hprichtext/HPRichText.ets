/**
 * HPRichText: https://github.com/asasugar/HPRichText
 * @Author: asasugar<xxj95719@gmail.com>
 */
import type { Nullable } from '../../common/types/common';
import type { Attr, HtmlParserResult, NodeInfo } from '../../common/types/htmlParser';
import type {
  FancyImageOptions,
  FancySpanOptions,
  fancyTextAreaOptions,
  fancyTextInputOptions,
  FancyTextOptions,
  fancyVideoOptions,
  LabelLevelBuilderOptions,
  LinkPressMethod,
  NodesBuilderOptions,
  RichTextOption,
  TextBuilderOptions
} from './index';
import HTMLParser from '../../common/utils/html/html-parser';

@Component
export struct HPRichText {
  @Link @Watch('onUpdateRichTextOption') richTextOption: RichTextOption;
  @Prop needScroll: boolean;
  onLinkPress: Nullable<LinkPressMethod> = null;
  @State htmlJson: HtmlParserResult = {
    nodes: []
  };

  getBlockIndex(node?: NodeInfo): number {
    const index = node?.nodes?.findIndex(n => n.tagType === 'block');
    return index as number;
  }

  /**
   * @description: Span文本样式构造器
   * @returns {*}
   */
  @Builder
  textBuilder($$: TextBuilderOptions) {
    Span($$.node.text)
      .fancySpan($$.parentNode?.artUIStyleObject)
      .onClick(() => {
        if ($$.parentNode?.tag !== 'a') return;

        // a标签增加回调事件
        try {
          this.onLinkPress?.({ text: $$.node.text, link: $$.parentNode?.attr?.href });
        } catch (error) {
          console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
        }
      })
  }

  /**
   * @description: 块级、行内标签拆分构造器
   * @returns {*}
   */
  @Builder
  labelLevelBuilder($$: LabelLevelBuilderOptions) {
    if ($$.node) {
      // 若找到块级标签
      if ($$.node.nodes && this.getBlockIndex($$.node) > -1) {
        // 块级标签不是第一项，则将行内标签元素统一处理
        if (this.getBlockIndex($$.node) > 0) {
          if (!$$.parentNode) {
            Text() {
              this.nodesBuilder({
                nodes: $$.node.nodes.slice(0, this.getBlockIndex($$.node)),
                parentNode: $$.node,
                isInlineBlockNesting: $$.isInlineBlockNesting
              });
            }
            .fancyText($$.node?.artUIStyleObject)
          } else {
            this.nodesBuilder({
              nodes: $$.node.nodes.slice(0, this.getBlockIndex($$.node)),
              parentNode: $$.node,
              isInlineBlockNesting: $$.isInlineBlockNesting
            });
          }
        }
        // 中间一项为单独的块级标签
        if (!$$.parentNode) {
          Text() {
            this.nodesBuilder({
              nodes: [$$.node.nodes[this.getBlockIndex($$.node)]],
              parentNode: $$.node,
            });
          }
          .fancyText($$.node.nodes[this.getBlockIndex($$.node)]?.artUIStyleObject)
        } else {

          this.nodesBuilder({
            nodes: [$$.node.nodes[this.getBlockIndex($$.node)]],
            parentNode: $$.node,
          });
        }

        // 第三项中判断还有剩余元素则递归处理
        // 可能还存在block
        if ($$.node.nodes.length - 1 > this.getBlockIndex($$.node)) {
          if (!$$.parentNode) {
            Text() {
              this.nodesBuilder({
                nodes: $$.node.nodes.slice(this.getBlockIndex($$.node) + 1),
                parentNode: $$.node,
              });
            }
            .border($$.node?.artUIStyleObject?.border)
            .fancyText($$.node?.artUIStyleObject)
          } else {
            this.nodesBuilder({
              nodes: $$.node.nodes.slice(this.getBlockIndex($$.node) + 1),
              parentNode: $$.node,
            });
          }
        }
      } else {
        // 长度为 1 直接渲染，降低复杂度
        if ($$.node.nodes?.length === 1 && $$.node.nodes[0].node === 'text') {
          if (!$$.parentNode) {
            Text() {
              this.textBuilder({ node: $$.node.nodes[0], parentNode: $$.node })
            }
            .fancyText($$.node?.artUIStyleObject)
          } else {
            this.textBuilder({ node: $$.node.nodes[0], parentNode: $$.node })
          }
        } else {
          if (!$$.parentNode) {
            Text() {
              this.nodesBuilder({
                nodes: $$.node.nodes,
                parentNode: $$.node,
                isInlineBlockNesting: $$.isInlineBlockNesting
              });
            }
            .fancyText($$.node?.artUIStyleObject)
          } else {
            this.nodesBuilder({
              nodes: $$.node.nodes,
              parentNode: $$.node,
              isInlineBlockNesting: $$.isInlineBlockNesting
            });
          }
        }
      }
    }
  }

  /**
   * @description: 节点构造器函数
   * @returns {*}
   */
  @Builder
  nodesBuilder($$: NodesBuilderOptions) {
    if ($$.nodes?.length) {
      ForEach($$.nodes, (item: NodeInfo) => {
        // 标签
        if (item.node === 'element') {
          // video
          if (item.tag === 'video') {
            Video({
              src: item.attr?.src
            })
              .fancyVideo(item?.artUIStyleObject, item?.attr);
          } else if (item.tag === 'img') {
            // img
            Image(item.attr?.src)
              .fancyImage(item?.artUIStyleObject, item?.attr);
          } else if (item.tag === 'input') {
            TextInput({ text: item?.attr?.value, placeholder: item?.attr?.placeholder })
              .fancyTextInput(item?.artUIStyleObject, item?.attr);
          } else if (item.tag === 'textarea') {
            TextArea({
              placeholder: item?.attr?.placeholder,
              text: item?.nodes?.[0]?.text
            })
              .fancyTextArea(item?.artUIStyleObject);
          } else {
            this.labelLevelBuilder({
              node: item,
              parentNode: $$.parentNode,
              isInlineBlockNesting: true
            });
          }
        } else if (item.node === 'text') {
          if (!$$.parentNode) {
            Text() {
              this.textBuilder({ node: item, parentNode: $$.parentNode });
            }
          } else {
            this.textBuilder({ node: item, parentNode: $$.parentNode });
          }
        }
      }, (item: NodeInfo, index: number) => Math.random().toFixed(3) + item.node + item.tag + item.tagType + index)
    }
  }

  // 监听到richTextOption参数变化则重新触发 HTML转化函数
  onUpdateRichTextOption() {
    const htmlParser = new HTMLParser(this.richTextOption?.customHandler, this.richTextOption?.imageProp, this.richTextOption?.baseFontSize);
    this.htmlJson = htmlParser.html2json(this.richTextOption.content);
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
  .decoration($$.decoration)
}

@Extend(Text)
function fancyText($$: FancyTextOptions = {}) {
  .width($$.width)
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
function fancyVideo($$: fancyVideoOptions = {}, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .muted(attrs.muted)
  .autoPlay(attrs.autoplay)
  .loop(attrs.loop)
  .controls(true) // 默认为非自定义控制器
  .objectFit(ImageFit.Contain)
}


@Extend(TextInput)
function fancyTextInput($$: fancyTextInputOptions = { fontSize: 14, fontColor: Color.Black }, attrs: Attr = {}) {
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
function fancyTextArea($$: fancyTextAreaOptions = {}) {
  .width($$.width)
  .height($$.height)
  .placeholderFont({ size: 16, weight: 400 })
  .fontSize($$.fontSize)
  .fontColor($$.fontColor)
  .backgroundColor($$.backgroundColor)
}