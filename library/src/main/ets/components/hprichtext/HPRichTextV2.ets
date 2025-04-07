/**
 * HPRichText: https://github.com/asasugar/HPRichText
 * @Author: asasugar<xxj95719@gmail.com>
 * 在@ComponentV2装饰的自定义组件中，开发者仅可以使用全新的状态变量装饰器，包括@Local、@Param、@Once、@Event、@Provider、@Consumer等。
 * @ComponentV2装饰的自定义组件暂不支持组件复用、LocalStorage等现有自定义组件的能力。
 * 无法同时使用@ComponentV2与@Component装饰同一个struct结构。
 * @ComponentV2支持一个可选的boolean类型参数freezeWhenInactive，来实现组件冻结功能。
 */
import type { HtmlParserResult, NodeInfo } from '../../common/types/htmlParser';
import type { FancySpanOptions, FancyTextOptions, NodesBuilderOptions, SpanBuilderInstall } from './index';
import HTMLParser from '../../common/utils/html/html-parser';
import { assign } from '../../common/utils/helperful';
import { RichTextOptionModelV2 } from './model/RichTextOptionModelV2';
import {
  containerSpanBuilder,
  imageBuilder,
  spanBuilder,
  textAreaBuilder,
  textInputBuilder,
  videoBuilder
} from './builder/index';
import { _isNeedRenderText, _setDefaultArtUI, getRandomKey } from './common';

@ComponentV2
export struct HPRichTextV2 {
  @Param
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  @Computed
  get htmlJson(): HtmlParserResult {
    const htmlParser = new HTMLParser(this.richTextModel.richTextOption);
    const htmlJson = htmlParser.html2json();
    // console.log('转化之后的html', JSON.stringify?.(htmlJson.nodes));
    return htmlJson;
  };

  @Computed
  get defaultArtUI(): FancySpanOptions {
    const defaultArtUI = _setDefaultArtUI(this.richTextModel.richTextOption) ?? {}; // 生成默认样式
    return defaultArtUI
  }

  @Computed
  get spanBuilderInstall(): SpanBuilderInstall {
    return {
      defaultArtUI: this.defaultArtUI,
      onLinkPress: this.richTextModel.onLinkPress
    }
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
            videoBuilder(item, this.richTextModel.onLinkPress)
          } else if (item.tag === 'img') {
            // img
            imageBuilder(item, this.richTextModel.onLinkPress, this.richTextModel.richTextOption)
          } else if (item.tag === 'input') {
            // input
            textInputBuilder(item)
          } else if (item.tag === 'textarea') {
            // textarea
            textAreaBuilder(item)
          } else if (item.nodes?.length) {
            if (item.addHarmonyTextTag && !$$.parentNode?.addHarmonyTextTag && !$$.alreadyAddText) {
              Text() {
                this.nodesBuilder({
                  nodes: item.nodes,
                  parentNode: item,
                  alreadyAddText: true // 避免重复添加Text标签，导致敲套 Text 造成渲染失效问题
                })
              }
              .fancyText(
                // 如果isInlinePushNode的节点则Text过滤掉背景色值跟borderRadius，交到第一个 ContainerSpan 节点处理
                item?.isInlinePushNode ?
                assign({}, item?.artUIStyleObject, { backgroundColor: null, borderRadius: null }) :
                  item?.artUIStyleObject
              )
              .copyOption(this.richTextModel.copyEnable ? CopyOptions.InApp : CopyOptions.None)
              .onCopy((val) => {
                console.log('%c [ val ]-90', 'font-size:13px; background:pink; color:#bf2c9f;', val)
                //执行回调
                if (this.richTextModel.onCopyPress) {
                  this.richTextModel.onCopyPress({ text: val })
                }
              })
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
              spanBuilder({ node: item, index: i, parentNode: $$.parentNode }, this.spanBuilderInstall);
            }
            .fancyText(item?.artUIStyleObject || $$.parentNode?.artUIStyleObject)
            .copyOption(this.richTextModel.copyEnable ? CopyOptions.InApp : CopyOptions.None)
            .onCopy((val) => {
              //执行回调
              if (this.richTextModel.onCopyPress) {
                this.richTextModel.onCopyPress({ text: val })
              }
            })
          } else {
            // isInlinePushNode的nodes则首位需要使用 ContainerSpan 单独处理背景色值跟边框radios
            if (item.artUIStyleObject?.backgroundColor || $$.parentNode?.artUIStyleObject?.backgroundColor) {
              containerSpanBuilder(
                {
                  node: item,
                  index: i,
                  parentNode: $$.parentNode
                },
                this.spanBuilderInstall
              )
            } else {
              spanBuilder(
                {
                  node: item,
                  index: i,
                  parentNode: $$.parentNode
                },
                this.spanBuilderInstall
              );
            }
          }
        }
      }, (item: NodeInfo, index: number) => getRandomKey(item, index))
    }
  }

  build() {
    if (this.richTextModel.needScroll) {
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