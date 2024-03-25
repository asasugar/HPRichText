/**
 * HPRichText: https://github.com/asasugar/HPRichText
 * @Author: asasugar<xxj95719@gmail.com>
 */
import type { Nullable } from '../../common/types/common';
import type { NodeInfo, HtmlParserResult, Attr } from '../../common/types/htmlParser';
import type {
  RichTextOption,
  TextBuilderOptions,
  LabelLevelBuilderOptions,
  NodesBuilderOptions,
  FancySpanOptions,
  FancyTextOptions,
  FancyImageOptions,
  fancyVideoOptions,
  fancyTextInputOptions,
  fancyTextAreaOptions,
  LinkPressMethod
} from './index';
import HTMLParser from '../../common/utils/html/html-parser';
import { assign } from './helperful';


@Component
export struct HPRichText {
  @Link richTextOption: RichTextOption;
  @Prop needScroll: boolean;
  onLinkPress: Nullable<LinkPressMethod> = null;
  private htmlJson: HtmlParserResult = {
    nodes: []
  };

  getBlockIndex(node: NodeInfo): number {
    const index = node?.nodes?.findIndex(node => node.tagType === 'block');
    return index as number;
  }

  @Builder
  labelLevelBuilder($$: LabelLevelBuilderOptions) {
    if ($$.node) {
      // 处理行内样式层级问题
      if ($$.node.nodes && this.getBlockIndex($$.node) > -1) {
        // 若找到块级标签，则三等分递归保证block标签是唯一的一项
        // 前面一项都是非block
        if (this.getBlockIndex($$.node) > 0) {
          Row() {
            Text() {
              this.nodesBuilder({
                nodes: $$.node.nodes.slice(0, this.getBlockIndex($$.node)),
                parentNode: $$.node,
              });
            }
            .fancyText($$.node?.artUIStyleObject)
          }
          .justifyContent(FlexAlign.End)
        }

        // 中间一项为单独的block
        this.nodesBuilder({
          nodes: [$$.node.nodes[this.getBlockIndex($$.node)]],
          parentNode: $$.node,
        });

        // 第三项中可能还存在block，所以需要递归处理第三项数据
        this.labelLevelBuilder({
          node: assign({}, $$.node, { nodes: $$.node.nodes.slice(this.getBlockIndex($$.node) + 1) }),
          parentNode: $$.node,
          isSetOutStyle: $$.isSetOutStyle
        })
      } else {
        if ($$.node.tagType === 'inline' && $$.parentNode) {
          this.nodesBuilder({
            nodes: $$.node.nodes,
            parentNode: $$.node,
          });
        } else {
          Text() {
            this.nodesBuilder({
              nodes: $$.node.nodes,
              parentNode: $$.node,
            });
          }
          .border(!$$.isSetOutStyle ? $$.node?.artUIStyleObject?.border : null)
          .fancyText($$.node?.artUIStyleObject)
        }
      }
    }

  }

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
              .fancyVideo(item?.artUIStyleObject, item?.attr)
          } else if (item.tag === 'img') {
            // img
            Image(item.attr?.src)
              .fancyImage(item?.artUIStyleObject, item?.attr);
          } else if (item.tag === 'input') {
            TextInput({ text: item?.attr?.value, placeholder: item?.attr?.placeholder })
              .fancyTextInput(item?.artUIStyleObject, item?.attr)
          } else if (item.tag === 'textarea') {
            TextArea({
              placeholder: item?.attr?.placeholder,
              text: item?.nodes?.[0]?.text
            })
              .fancyTextArea(item?.artUIStyleObject)

          } else {
            // 处理子节点
            Column() {
              this.labelLevelBuilder({
                node: item,
                parentNode: $$.parentNode,
                isSetOutStyle: this.getBlockIndex(item) > -1
              })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .border(this.getBlockIndex(item) > -1 ? item?.artUIStyleObject?.border : null)
          }
        } else if (item.node === 'text') {
          if ($$.parentNode) {
            this.textBuilder({ node: item, parentNode: $$.parentNode });
          } else {
            // 纯文本，无标签场景
            Text() {
              this.textBuilder({ node: item, parentNode: $$.parentNode });
            }
          }
        }
      }, (item: NodeInfo, index: number) => index + item.node)
    }
  }

  // 文本样式构造器
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

  aboutToAppear() {
    const htmlParser = new HTMLParser(this.richTextOption?.customHandler, this.richTextOption?.imageProp);
    this.htmlJson = htmlParser.html2json(this.richTextOption.content);
    // console.log('转化之后的html', JSON.stringify?.(this.htmlJson.nodes));
  }

  build() {
    if (this.needScroll) {
      Scroll() {
        Column() {
          this.nodesBuilder({ nodes: this.htmlJson.nodes });
        }
        .alignItems(HorizontalAlign.Start)
      }
    } else {
      Column() {
        this.nodesBuilder({ nodes: this.htmlJson.nodes });
      }
      .alignItems(HorizontalAlign.Start)
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
    attrs.type === 'number' ? InputType.Number :
      attrs.type === 'tel' ? InputType.PhoneNumber :
        attrs.type === 'password' ? InputType.Password :
          attrs.type === 'email' ? InputType.Email :
          InputType.Normal
  )
  .placeholderColor(Color.Grey)
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