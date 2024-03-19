import type { NodeInfo, HtmlParserResult, RichTextOption } from '../../common/types/HtmlParser';
import HTMLParser from '../../common/utils/html/html-parser';

@Component
export struct HPRichText {
  @Link richTextOption: RichTextOption;
  private htmlJson: HtmlParserResult = {};

  getBlockIndex(node: NodeInfo): number {
    const index = node?.nodes?.findIndex(node => node.tagType === 'block');
    return index;
  }

  getSpecialIndex(node: NodeInfo): number {
    const index = node.nodes?.findIndex(node => node.tag === 'video' || node.tag === 'img' || node.tag === 'input' || node.tag === 'textarea');
    return index;
  }

  @Builder labelLevelBuilder($$: {
    node: NodeInfo;
    parentNode: NodeInfo;
    isSetOutStyle: boolean;
  }) {
    if ($$.node) {
      // 处理行内样式层级问题
      if (this.getBlockIndex($$.node) > -1) {
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
          node: Object.assign({}, $$.node, { nodes: $$.node.nodes.slice(this.getBlockIndex($$.node) + 1) }),
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

  @Builder nodesBuilder($$: {
    nodes: NodeInfo[];
    parentNode?: NodeInfo;
  }) {
    if ($$.nodes?.length) {

      ForEach($$.nodes, (item) => {
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
      }, (item, index) => index + item.node)

    }
  }

  // 文本样式构造器
  @Builder textBuilder($$: {
    node: NodeInfo;
    parentNode: NodeInfo;
  }) {
    // a标签增加点击事件
    if ($$.node.tag === 'a') {
      Text() {
        Span($$.node.text)
          .fancySpan($$.parentNode?.artUIStyleObject)
      }
      .fancyText($$.parentNode?.artUIStyleObject)
      .onClick(() => {
        try {
          // 等待真机验证
        } catch (error) {
          console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
        }
      })
    } else {
      Span($$.node.text)
        .fancySpan($$.parentNode?.artUIStyleObject);
    }
  }

  aboutToAppear() {
    const htmlParser = new HTMLParser({
      customHandler: this.richTextOption?.customHandler,
      imageProp: this.richTextOption?.imageProp
    });
    this.htmlJson = htmlParser.html2json(this.richTextOption.content);
    console.log('转化之后的html', JSON.stringify?.(this.htmlJson.nodes));
  }

  build() {
    Scroll() {
      Column() {
        this.nodesBuilder({ nodes: this.htmlJson.nodes });
      }
      .alignItems(HorizontalAlign.Start)
    }
  }
}


@Extend(Span) function fancySpan({  decoration, letterSpacing, fontColor, fontSize, fontStyle, fontWeight, fontFamily}: Record<string, any>={
}) {
  .fontColor(fontColor)
  .fontSize(fontSize)
  .fontStyle(fontStyle)
  .fontWeight(fontWeight)
  .fontFamily(fontFamily)
  .letterSpacing(letterSpacing)
  .decoration(decoration)
}

@Extend(Text) function fancyText({flexBasis, flexGrow, flexShrink, alignSelf, clip, width, height, margin, padding, linearGradient, zIndex, opacity, backgroundColor, backgroundImage, backgroundRepeat, backgroundImageSize, backgroundImagePosition, rotate, scale, translate, transform, visibility, offset, decoration, lineHeight, letterSpacing, fontColor, fontSize, fontStyle, fontWeight, fontFamily, textOverflow, maxLines,textAlign }: Record<string, any>={
}) {
  .flexBasis(flexBasis)
  .flexGrow(flexGrow)
  .flexShrink(flexShrink)
  .alignSelf(alignSelf)
  .clip(clip)
  .width(width)
  .height(height)
  .margin(margin)
  .padding(padding)
  .linearGradient(linearGradient)
  .zIndex(zIndex)
  .opacity(opacity)
  .backgroundColor(backgroundColor)
  .backgroundImage(backgroundImage)
  .backgroundImageSize(backgroundImageSize)
  .backgroundImagePosition(backgroundImagePosition)
  .rotate(rotate)
  .scale(scale)
  .translate(translate)
  .transform(transform)
  .visibility(visibility)
  .offset(offset)
  .decoration(decoration)
  .lineHeight(lineHeight)
  .letterSpacing(letterSpacing)
  .fontColor(fontColor)
  .fontSize(fontSize)
  .fontWeight(fontWeight)
  .fontFamily(fontFamily)
  .textAlign(textAlign)
  .textOverflow(textOverflow)
  .maxLines(maxLines ? Number(maxLines) : textOverflow ? 1 : null)
}

@Extend(Image) function fancyImage({ width, height, margin, padding, opacity ,objectFit}: Record<string, any>={
}, { alt }: Record<string, any>={}) {
  .width(width)
  .height(height)
  .margin(margin)
  .padding(padding)
  .alt(alt)
  .opacity(opacity)
  .objectFit(objectFit)
}

@Extend(Video) function fancyVideo({ width,height }: Record<string, any>={
}, { muted, autoplay, loop }: Record<string, any>={}) {
  .width(width)
  .height(height)
  .muted(muted)
  .autoPlay(autoplay)
  .loop(loop)
  .controls(true) // 默认为非自定义控制器
  .objectFit(ImageFit.Contain)
}

@Extend(TextInput) function fancyTextInput({ width, height, fontSize = 14, fontColor = Color.Black}: Record<string, any> = {
}, { type, maxlength, pattern }: Record<string, any> = {}) {
  .width(width)
  .height(height)
  .type(
      type === 'number' ? InputType.Number :
        type === 'tel' ? InputType.PhoneNumber :
          type === 'password' ? InputType.Password :
            type === 'email' ? InputType.Email :
          InputType.Normal
  )
  .placeholderColor(Color.Grey)
  .placeholderFont({ size: 14, weight: 400 })
  .fontSize(fontSize)
  .fontColor(fontColor)
  .maxLength(maxlength)
  .inputFilter(pattern, (e) => {
    console.log(JSON.stringify(e))
  })
}

@Extend(TextArea) function fancyTextArea({ width, height, fontSize = 14, fontColor = Color.Black, backgroundColor }: Record<string, any> = {
}) {
  .width(width)
  .height(height)
  .placeholderFont({ size: 16, weight: 400 })
  .fontSize(fontSize)
  .fontColor(fontColor)
  .backgroundColor(backgroundColor)
}