import type { NodeInfo, HtmlParserResult } from '../../common/types/HtmlParser';
import HTMLParser from '../../common/utils/html/html-parser';
import RichTextDataSource from '../../viewModel/RichTextDataSource';

@Component
export struct HPRichText {
  @Prop content: string;
  private htmlJson: HtmlParserResult = {};

  getBlockIndex(node: NodeInfo): number {
    const index = node.nodes.findIndex(node => node.tagType === 'block');
    return index;
  }

  @Builder labelLevelBuilder($$: {
    node: NodeInfo
  }) {
    if ($$.node) {
      // 处理行内样式层级问题
      if (this.getBlockIndex($$.node) > -1) {
        // 若找到块级标签，则三等分递归保证block标签是唯一的一项
        // 前面一项都是非block
        Row() {
          this.inlineNodesBuilder({
            nodes: $$.node.nodes.slice(0, this.getBlockIndex($$.node)),
            parentNode: $$.node
          });
        }
        // 中间一项为单独的block
        this.inlineNodesBuilder({
          nodes: [$$.node.nodes[this.getBlockIndex($$.node)]],
          parentNode: $$.node
        });

        // 第三项中可能还存在block，所以需要递归处理第三项数据
        this.labelLevelBuilder({
          node: Object.assign({}, $$.node, { nodes: $$.node.nodes.slice(this.getBlockIndex($$.node) + 1) }),
        })
      } else {
        // Row() {
        this.inlineNodesBuilder({
          nodes: $$.node.nodes,
          parentNode: $$.node
        });
        // }
      }
    }
  }

  @Builder inlineNodesBuilder($$: {
    nodes: NodeInfo[],
    parentNode?: NodeInfo
  }) {
    if ($$.nodes.length) {

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
            // 处理行内样式层级问题
            if (this.getBlockIndex(item) > -1) {
              this.labelLevelBuilder({ node: item })
            } else {
              this.inlineNodesBuilder({ nodes: item.nodes, parentNode: item });
            }
          }
        } else if (item.node === 'text') {
          Row() {
            this.textBuilder({ node: item, parentNode: $$.parentNode });
          }
        }
      }, (item, index) => index + item.node)
    }
  }
  // element类型的节点构造器内容
  @Builder nodesBuilder($$: {
    nodes: NodeInfo[],
    parentNode?: NodeInfo
  }) {

    // 遍历
    List({ space: 0 }) {
      // List、Grid、Swiper以及WaterFlow
      LazyForEach(new RichTextDataSource($$.nodes), (item, index) => {

        if (item.tagType !== 'block' && $$.nodes) {

        }
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
            } else {
              this.nodesBuilder({ nodes: item.nodes, parentNode: item });

              // 如果nodes列表中下一个节点是inline类型，则需要处理为同层级使用Row包裹
              if (item.nodes[index] && item.nodes?.[index + 1]?.tagType === 'inline') {
                Row() {
                  // 纯文本
                  if (item.nodes[index].node === 'text') {
                    // this.textBuilder({
                    //   text: item.nodes[index]?.text,
                    //   tag: item?.tag,
                    //   artUIStyleObject: item.artUIStyleObject,
                    //   attr: item.attr
                    // });
                  }

                  this.nodesBuilder({ nodes: item.nodes.slice(1), parentNode: item });
                }
              } else {

                this.nodesBuilder({ nodes: item.nodes, parentNode: item });
              }
            }
          }
        } else if (item.node === 'text') {
          // 纯文本
          // this.textBuilder({
          //   text: item?.text,
          //   tag: $$.parentNode?.tag,
          //   artUIStyleObject: $$.parentNode.artUIStyleObject,
          //   attr: $$.parentNode.attr
          // });
        }
      }, (item, index) => index + item.node);
    }
    .listDirection(Axis.Vertical) // 排列方向
    .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
    .width('100%')
  }

  // 文本样式构造器
  @Builder textBuilder($$: {
    node: NodeInfo,
    parentNode: NodeInfo
  }) {

    // a标签增加点击事件
    if ($$.node.tag === 'a') {
      Text($$.node.text)
        .fancyText($$.parentNode?.artUIStyleObject)
        .onClick(() => {
          try {
            // 等待真机验证
          } catch (error) {
            console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
          }
        })
    } else {
      Text($$.node.text)
        .fancyText($$.parentNode?.artUIStyleObject);
    }
  }

  aboutToAppear() {
    const htmlParser = new HTMLParser();
    this.htmlJson = htmlParser.html2json(this.content);
    console.log('转化之后的html11', JSON.stringify(this.htmlJson.nodes));
  }

  build() {
    this.inlineNodesBuilder({ nodes: this.htmlJson.nodes });

    // this.nodesBuilder({ nodes: this.htmlJson.nodes });
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