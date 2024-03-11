import type { NodeInfo, HtmlParserResult } from '../../common/types/HtmlParser';
import HTMLParser from '../../common/utils/html/html-parser';
import RichTextDataSource from '../../viewModel/RichTextDataSource';

@Component
export struct HPRichText {
  @Prop content: string;
  private htmlJson: HtmlParserResult = {};

  // element类型的节点构造器内容
  @Builder nodesBuilder($$: {
    nodes: NodeInfo[],
    paramsNodes?: NodeInfo
  }) {
    // 遍历
    List({ space: 0 }) {
      // List、Grid、Swiper以及WaterFlow
      LazyForEach(new RichTextDataSource($$.nodes), (item, index) => {
        // 标签
        if (item.node === 'element') {
          ListItem() {
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
            } else if (item.nodes.length) {
              // 如果nodes列表中下一个节点是inline类型，则需要处理为同层级使用Row包裹
              if (item.nodes[index] && item.nodes?.[index + 1]?.tagType === 'inline') {
                Row() {
                  // 纯文本
                  if (item.nodes[index].node === 'text') {
                    this.textBuilder({
                      text: item.nodes[index]?.text,
                      tag: item?.tag,
                      artUIStyleObject: item.artUIStyleObject,
                      attr: item.attr
                    });
                  }

                  this.nodesBuilder({ nodes: item.nodes.slice(1), paramsNodes: item });
                }
              } else {

                this.nodesBuilder({ nodes: item.nodes, paramsNodes: item });
              }
            }
          }
        } else if (item.node === 'text') {
          // 纯文本
          this.textBuilder({
            text: item?.text,
            tag: $$.paramsNodes?.tag,
            artUIStyleObject: $$.paramsNodes.artUIStyleObject,
            attr: $$.paramsNodes.attr
          });
        }
      }, (item, index) => index + item.node);
    }
    .listDirection(Axis.Vertical) // 排列方向
    .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
    .width('100%');
  }

  // 文本样式构造器
  @Builder textBuilder($$: Pick<NodeInfo, 'text' | 'tag' | 'artUIStyleObject' | 'attr'>) {
    // a标签增加点击事件
    if ($$.tag === 'a') {
      Text($$.text)
        .fancyText($$.artUIStyleObject)
        .onClick(() => {
          try {
            // 等待真机验证
          } catch (error) {
            console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
          }
        })
    } else {
      Text($$.text)
        .fancyText($$.artUIStyleObject);
    }
  }

  aboutToAppear() {
    const htmlParser = new HTMLParser();
    this.htmlJson = htmlParser.html2json(this.content);
    console.log('转化之后的html11', JSON.stringify(this.htmlJson));
  }

  build() {
    this.nodesBuilder({ nodes: this.htmlJson.nodes });
  }
}


@Extend(Text) function fancyText({ flexBasis, flexGrow, flexShrink, alignSelf, clip, width, height, margin, padding, linearGradient, zIndex, border, opacity, backgroundColor, backgroundImage, backgroundRepeat, backgroundImageSize, backgroundImagePosition, rotate, scale, translate, transform, visibility, offset, decoration, lineHeight, letterSpacing, fontColor, fontSize, fontStyle, fontWeight, fontFamily, textOverflow, textAlign }: Record<string, any>={
}) {
  // TODO: 增加textOverflow属性就会报错，暂时先不加
  // .maxLines(styleObj?.['text-overflow'] === 'ellipsis' ? 1 : styleObj?.['-webkit-line-clamp'] ?? 999999)
  // .textOverflow({
  //   overflow: (styleObj?.['text-overflow'] === 'ellipsis' || styleObj?.['-webkit-line-clamp']) ? TextOverflow.Ellipsis : TextOverflow.None
  // })
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
  .border(border)
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
}

@Extend(Image) function fancyImage({ width, height, margin, padding, opacity }: Record<string, any>={
}, { alt }: Record<string, any>={}) {
  .width(width)
  .height(height)
  .margin(margin)
  .padding(padding)
  .alt(alt)
  .opacity(opacity)
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