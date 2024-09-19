/**
 * HPRichText: https://github.com/asasugar/HPRichText
 * @Author: asasugar<xxj95719@gmail.com>
 */
import type { HtmlParserResult, NodeInfo } from '../../common/types/htmlParser';
import type {
  FancyContainerSpanOptions,
  FancySpanOptions,
  FancyTextOptions,
  LinkPressMethod,
  NodesBuilderOptions
} from './index';
import HTMLParser from '../../common/utils/html/html-parser';
import { RichTextOptionModel } from './model/RichTextOptionModel';
import { imageBuilder, spanBuilder, textAreaBuilder, textInputBuilder, videoBuilder } from './builder/index';
import { _isNeedRenderText, _setDefaultArtUI, getRandomKey } from './common';

@Component
export struct ObservedHPRichText {
  @ObjectLink @Watch('onUpdateRichTextOption') observedRichTextOption: RichTextOptionModel;
  @Prop needScroll: boolean;
  onLinkPress?: LinkPressMethod;
  @State htmlJson: HtmlParserResult = {
    nodes: []
  };
  @State defaultArtUI: FancySpanOptions = {};

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
            videoBuilder(item, this.onLinkPress)
          } else if (item.tag === 'img') {
            // img
            imageBuilder(item, this.onLinkPress)
          } else if (item.tag === 'input') {
            // input
            textInputBuilder(item)
          } else if (item.tag === 'textarea') {
            // textarea
            textAreaBuilder(item)
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
          if (_isNeedRenderText($$)) {
            Text() {
              spanBuilder(
                {
                  node: item,
                  index: i,
                  parentNode: $$.parentNode
                },
                {
                  defaultArtUI: this.defaultArtUI,
                  onLinkPress: this.onLinkPress
                }
              );
            }
            .fancyText(item?.artUIStyleObject || $$.parentNode?.artUIStyleObject)
          } else {
            // isInlinePushNode的nodes则首位需要单独处理背景色值跟边框radios
            if ($$.parentNode?.isInlinePushNode && i === 0) {
              ContainerSpan() {
                spanBuilder(
                  {
                    node: item,
                    index: i,
                    parentNode: $$.parentNode
                  },
                  {
                    defaultArtUI: this.defaultArtUI,
                    onLinkPress: this.onLinkPress
                  }
                );
              }
              .fancyContainerSpan($$.parentNode.artUIStyleObject)
            } else {
              spanBuilder(
                {
                  node: item,
                  index: i, parentNode: $$.parentNode
                },
                {
                  defaultArtUI: this.defaultArtUI,
                  onLinkPress: this.onLinkPress
                }
              );
            }
          }
        }
      }, (item: NodeInfo, index: number) => getRandomKey(item, index))
    }
  }

  // 监听到richTextOption参数变化则重新触发 HTML转化函数
  onUpdateRichTextOption() {
    const htmlParser = new HTMLParser(this.observedRichTextOption);
    this.htmlJson = htmlParser.html2json();
    // console.log('转化之后的html', JSON.stringify?.(this.htmlJson.nodes));
  }

  // 初始化更新
  aboutToAppear() {
    if (this.observedRichTextOption?.content) {
      this.defaultArtUI = _setDefaultArtUI(this.observedRichTextOption); // 生成默认样式
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

@Extend(ContainerSpan)
function fancyContainerSpan($$: FancyContainerSpanOptions = {}) {
  .textBackgroundStyle({ color: $$.backgroundColor, radius: $$.borderRadius as Dimension | BorderRadiuses })
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