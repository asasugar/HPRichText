import type { NodeInfo, HtmlParserResult } from '../../common/types/HtmlParser';
import HTMLParser from '../../common/utils/html/html-parser';
import Node from '../../common/utils/html/node';
import RichTextDataSource from '../../viewModel/RichTextDataSource';

@Component
export struct HPRichText {
  @Prop content: string;
  private htmlJson: HtmlParserResult = {};

  getBlockIndex(node: NodeInfo): number {
    const index = node.nodes?.findIndex(node => node.tagType === 'block');
    return index;
  }

  @Builder labelLevelBuilder($$: {
    node: NodeInfo;
    parentNode: NodeInfo
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
          parentNode: $$.node
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
              src: item.attr?.src,
              previewUri: item.attr?.poster,
            })
              .fancyVideo(item?.artUIStyleObject, item?.attr)
          } else if (item.tag === 'img') {
            // img
            Image(item.attr?.src)
              .fancyImage(item?.artUIStyleObject, item?.attr);
          } else {
            // 处理子节点
            Column() {
              this.labelLevelBuilder({ node: item, parentNode: $$.parentNode })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .border(item?.artUIStyleObject?.border)
          }
        } else if (item.node === 'text') {
          // if ($$.nodes.length === 1) {
          //   Text() {
          //     this.textBuilder({ node: item, parentNode: $$.parentNode });
          //   }
          // } else {
          this.textBuilder({ node: item, parentNode: $$.parentNode });
          // }
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
    const htmlParser = new HTMLParser({ imageProp: { webp: true } });
    this.htmlJson = htmlParser.html2json(this.content);
    console.log('转化之后的html', JSON.stringify?.(this.htmlJson));
  }

  build() {
    this.nodesBuilder({ nodes: this.htmlJson.nodes });
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
  .maxLines(Number(maxLines))
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
}, {muted,autoplay,loop}: Record<string, any>={}) {
  .width(width)
  .height(height)
  .muted(muted)
  .autoPlay(autoplay)
  .loop(loop)
  .controls(true) // 默认为非自定义控制器
  .objectFit(ImageFit.Contain)
}