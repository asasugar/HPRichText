import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <div><font color="red">兑换说明</font><br>赠送12.0%；<br></div>
    <div><font color="red">兑换说明</font><br><font color="blue">赠送12.0%；</font><br></div>
    <font color="red">兑换说明</font><br><font color="blue">赠送12.0%；</font><br>
    <font color="red">兑换说明</font><font color="blue">赠送12.0%；</font><br>
       `,
    imageProp: {
      webp: true,
    }
  };
  @State text: string = ''

  build() {
    Column() {
      HPRichText({
        richTextOption: $richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          return e;
        }
      })
    }
  }
}