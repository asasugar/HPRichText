import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear() {
    this.richTextModel.richTextOption = {
      content: `
        <div>
        <p>aaaaaaaaaaaaaaaaaaaaaaaaa<span></span></p>
        <p>aaaaaaaaaaaaaaaaa<span></span></p>
        <p>bbbbbbbbbb<span></span></p>
        <p>ccccccccccccccccccc<span></span></p>
        <p>dddddddddddddddddddddd<span></span></p>
        <p>eeeeeeeeeeeeeeeeeeeeeee<span></span></p>
        <p>fffffffffffffffffff</p>
        <p><span></span><br /></p>
        <p><span></span><strong>eeeeeeeeeeeee</strong></p>
        </div>
    `,
      imageProp: {
        webp: true,
      },
    }
    this.richTextModel.needScroll = true;
    this.richTextModel.onLinkPress = (e) => {
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