import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    baseFontSize: 30,
    baseFontColor: "#99000000",
    content: `
    <span style='text-align:center;'>您好, 现在会员促销期间<font color='red'>打6折</font>哟~错过时间<font color='red'>恢复原价</font>哈!</span>
    `,
  };
  @State text: string = ''
  @State handlePopup: boolean = false
  @State customPopup: boolean = false

  build() {
    Column() {
      HPRichText({
        richTextOption: $richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          console.log(JSON.stringify(e))
          return e;
        }
      })

    }
  }
}