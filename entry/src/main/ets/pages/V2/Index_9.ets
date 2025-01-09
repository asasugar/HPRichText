import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear() {
    this.richTextModel.richTextOption = {
      content: `
      <div style='text-align: center;'><span style='color: #414141;font-family: PingFang SC;font-size: 12px'>现在分享有机会获取<span style='color: #FF4D00;'><b> 20 </b></span>积分，好友打开再得<span style='color: #FF4D00;'><b> 12 </b></span>积分<br/>积分可<span style='color: #FF4D00;'><b>兑换好礼</b></span></span></div>
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