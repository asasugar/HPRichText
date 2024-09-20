import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear() {
    this.richTextModel.richTextOption = {
      baseFontSize: 30,
      content: `
    <a href='https://u.jd.com/R8nDgYF'>点击链接1 </a> 测试链接1<br><a href='https://jingfen.jd.com/item'>点击链接2 </a> 测试链接2<br>测试链接2<br><a href='https://jingfen.jd.com/item.html'>购买 </a>
    `,
      imageProp: {
        webp: true,
      },
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