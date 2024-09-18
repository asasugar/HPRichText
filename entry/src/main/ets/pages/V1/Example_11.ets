import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    baseFontSize: 15,
    baseFontColor: "#99000000",
    content: `
    <span style='text-align:center;'>您好, 现在会员促销期间<font color='red'>打6折</font>哟~错过时间<font color='red'>恢复原价</font>哈!</span>
       `,
    imageProp: {
      webp: true,
    }
  };

  build() {
    Column() {
      HPRichText({
        richTextOption: $richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          return e;
        }
      }).padding({
        left: 18,
        right: 18,
        top: 10,
        bottom: 15
      })
        .width("100%")
        .align(Alignment.Center)
        .constraintSize({
          minHeight: 88
        })
    }
  }
}