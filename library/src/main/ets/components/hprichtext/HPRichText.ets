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
  @Link richTextOption: RichTextOption;
  @Prop needScroll: boolean;
  onLinkPress: Nullable<LinkPressMethod> = null;
  private htmlJson: HtmlParserResult = {
    nodes: []
  };

  getBlockIndex(node?: NodeInfo): number {
    const index = node?.nodes?.findIndex(node => node.tagType === 'block');
    return index as number;
  }

  getInlineIndex(node?: NodeInfo): number {
    const index = node?.nodes?.findIndex(node => node.tagType === 'inline');
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
      // 若找到块级标签且块级标签不是第一项，则二分数组处理
      if ($$.node.nodes && this.getBlockIndex($$.node) > 0) {
        // 处理行内样式层级问题
        Text() {
          this.nodesBuilder({
            nodes: $$.node.nodes.slice(0, this.getBlockIndex($$.node)),
            parentNode: $$.node,
            isInlineBlockNesting: $$.isInlineBlockNesting
          });
        }
        .fancyText($$.node?.artUIStyleObject)

        // 处理剩余数组：可能还存在block
        this.nodesBuilder({
          nodes: $$.node.nodes.slice(this.getBlockIndex($$.node)),
          parentNode: $$.node,
          isInlineBlockNesting: false
        })
      } else {
        // inline标签
        if (($$.node.tagType === 'inline' && $$.parentNode?.tagType === 'block')) {
          // 长度为 1 直接渲染，降低复杂度
          if ($$.node.nodes?.length === 1 && $$.node.nodes?.[0].node === 'text') {
            this.textBuilder({ node: $$.node.nodes[0], parentNode: $$.node })
          } else {
            this.nodesBuilder({
              nodes: $$.node.nodes,
              parentNode: $$.node,
              isInlineBlockNesting: $$.isInlineBlockNesting
            });
          }
        } else {

          // block标签
          // 长度为 1 直接渲染，降低复杂度
          if ($$.node.nodes?.length === 1 && $$.node.nodes[0].node === 'text') {
            Text() {
              this.textBuilder({ node: $$.node.nodes[0], parentNode: $$.node })
            }
            .border(!$$.isInlineBlockNesting ? $$.node?.artUIStyleObject?.border : null)
            .fancyText($$.node?.artUIStyleObject)
          } else {
            Text() {
              this.nodesBuilder({
                nodes: $$.node.nodes,
                parentNode: $$.node,
                isInlineBlockNesting: $$.isInlineBlockNesting
              });
            }
            .border(!$$.isInlineBlockNesting ? $$.node?.artUIStyleObject?.border : null)
            .fancyText($$.node?.artUIStyleObject)
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
    if ($$.nodes?.length && $$.parentNode) {
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
            // 处理子节点
            if ($$.isInlineBlockNesting || (this.getInlineIndex(item) > -1 && this.getBlockIndex(item) > -1)) {
              this.labelLevelBuilder({
                node: item,
                parentNode: $$.parentNode,
                isInlineBlockNesting: true
              });
            } else {

              if ($$.isInlineBlockNesting) {
                Text() {
                  this.nodesBuilder({
                    nodes: item.nodes,
                    parentNode: item,
                  });
                }
              }
              this.nodesBuilder({
                nodes: item.nodes,
                parentNode: item,
              });
            }
          }
        } else if (item.node === 'text') {
          if ($$.parentNode && this.getInlineIndex(item) > -1 && this.getBlockIndex(item) > -1) {
            this.textBuilder({ node: item, parentNode: $$.parentNode });
          } else {
            Text() {
              this.textBuilder({ node: item, parentNode: $$.parentNode });
            }
            .border(!$$.isInlineBlockNesting ? $$.parentNode?.artUIStyleObject?.border : null)
            .fancyText($$.parentNode?.artUIStyleObject);
          }
        }
      }, (item: NodeInfo, index: number) => index + item.node)
    }
  }

  aboutToAppear() {
    const htmlParser = new HTMLParser(this.richTextOption?.customHandler, this.richTextOption?.imageProp);
    this.htmlJson = htmlParser.html2json(this.richTextOption.content);
    // console.log('转化之后的html', JSON.stringify?.(this.htmlJson.nodes));
  }

  build() {
    if (this.needScroll) {
      Scroll() {
        Column() {
          this.nodesBuilder({ nodes: this.htmlJson.nodes, parentNode: this.htmlJson as NodeInfo });
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
  .offset($$.offset)
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