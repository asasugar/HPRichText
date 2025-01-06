import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear() {
    this.richTextModel.richTextOption = {
      content: `If you have read and agree to <span data-id="span_1" onClick="handleSpanClick1" style="font-weight:400;color:#0055FF;">User Agreement</span><span> and </span><span data-id="span_2" onClick="handleSpanClick2" style="font-weight:400;color:#0055FF;">Privacy Policy</span><span>（</span><span data-id="span_3" onClick="handleSpanClick3" style="font-weight:400;color:#0055FF;">Summary of Privacy Policy</span><span>）, please click the Agree button below to enter the service.</span>
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