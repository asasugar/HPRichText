import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear() {
    this.richTextModel.richTextOption = {
      content: `
      什么呀<span onClick="handleSpanClick" style="font-weight:700;color:#0055FF"> 《用户协议》</span>什么玩意
      `,
    }
    this.richTextModel.needScroll = true;
    this.richTextModel.onLinkPress = (e) => {
      console.log("点击：", JSON.stringify(e))
      return e;
    };
  }

  build() {
    Column() {
      HPRichTextV2({
        richTextModel: this.richTextModel
      })
    }
  }
}