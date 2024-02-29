import type { NodeInfo } from '../../common/types/HtmlParser';
import { parseToArtUI } from '../../common/utils/css';
import HTMLParser from '../../common/utils/html/html-parser';
import RichTextDataSource from '../../viewModel/RichTextDataSource';

@Component
export struct HPRichText {
  @Prop content: string;
  private htmlJson: RichTextDataSource<NodeInfo> = new RichTextDataSource([]);
  // node子节点构造器内容
  @Builder nodeBuilder($$: {
    node: NodeInfo,
    paramsNodes?: NodeInfo
  }) {
    // 标签
    if ($$.node.node === 'element') {
      // a
      if ($$.node.tag === 'a') {
        Row() {
          if ($$.node.nodes.length) {
            this.nodesBuilder({ nodes: new RichTextDataSource<NodeInfo>($$.node.nodes), paramsNodes: $$.node });
          }
        }
      } else if ($$.node.tag === 'video') {
        // video
        Video({
          src: $$.node.attr?.src,
          previewUri: $$.node.attr?.poster,
        })
          .width($$.node.attr?.width || '100%')
          .height($$.node.attr?.height || '100%')
          .objectFit(ImageFit.Contain)
          .muted($$.node.attr?.muted)
          .autoPlay($$.node.attr?.autoplay)
          .controls(true) // 默认为非自定义控制器
          .loop($$.node.attr?.loop);
      } else if ($$.node.tag === 'img') {
        // img
        Image($$.node.attr?.src)
          // @ts-ignore
          .width($$.node?.attr?.style?.width)
            // @ts-ignore
          .height($$.node?.attr?.style?.height)
          .alt($$.node.attr?.alt);
      } else {
        // Row() {
        // 其他
        if ($$.node.nodes.length) {
          this.nodesBuilder({ nodes: new RichTextDataSource<NodeInfo>($$.node.nodes), paramsNodes: $$.node });
        }
        // }
      }
    } else {
      // 纯文本
      this.textBuilder({ text: $$.node?.text, tag: $$.paramsNodes?.tag, style: $$.paramsNodes.attr.style });
    }
  }

  // node列表节点构造器内容
  @Builder nodesBuilder($$: {
    nodes: RichTextDataSource<NodeInfo>,
    paramsNodes?: NodeInfo
  }) {
    List({ space: 0 }) {
      // List、Grid、Swiper以及WaterFlow
      LazyForEach($$.nodes, (item) => {
        ListItem() {
          this.nodeBuilder({ node: item, paramsNodes: $$.paramsNodes });
        }
      }, (item, index) => index + item.node);
    }
    .listDirection(Axis.Vertical) // 排列方向
    .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
    .width('100%');
  }

  // 文本样式构造器
  @Builder textBuilder($$: {
    text: string,
    tag: string,
    style: NodeInfo['attr']['style']
  }) {
    // a标签默认: 蓝色+下划线+点击事件
    if ($$.tag === 'a') {
      Text($$.text)
        // @ts-ignore
        .fancyText($$.style as TextAttribute)
        .decoration({ type: TextDecorationType.Underline, color: Color.Blue })
    } else {
      Text($$.tag)
        .flexBasis(0)
        .width(100)
      Text($$.text)
        // @ts-ignore
        .fancyText(parseToArtUI($$.style));
    }
  }

  aboutToAppear() {
    const htmlParser = new HTMLParser()
    // @ts-ignore
    this.htmlJson = new RichTextDataSource(htmlParser.html2json(this.content).nodes);

    console.log('1111222', JSON.stringify(htmlParser.html2json(this.content)));
  }

  build() {
    this.nodesBuilder({ nodes: this.htmlJson });
  }
}


@Extend(Text) function fancyText({ flexBasis,flexGrow,flexShrink,alignSelf,clip,width,height,margin,padding,linearGradient,zIndex,border, opacity,backgroundColor,backgroundImage,backgroundRepeat,backgroundImageSize,backgroundImagePosition,rotate,scale,translate,transform,visibility,offset,decoration,lineHeight,letterSpacing,fontColor,fontSize,fontStyle,fontWeight,fontFamily,textOverflow,textAlign }) {
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
