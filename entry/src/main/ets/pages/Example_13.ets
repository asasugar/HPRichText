import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    baseFontSize: 17,
    baseFontColor: '#333333',
    content: `<font color='#fe89c7'>宝宝</font><font color='#fe89c7'>不爱吃饭</font>别怕！有它轻松拿捏挑食<font color='#fe89c7'>宝宝</font>！我家<font color='#fe89c7'>宝宝</font>不知是随...#<font color='#fe89c7'>宝宝</font>营养补充#`,
  };
  @State text: string = ''

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