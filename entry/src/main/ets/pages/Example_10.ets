import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    baseFontSize: 50,
    content: `
    <span style=\"color:#999999;\">该手机实名人需与我的我的为<\span><span style=\"color:#E53333;\">同一人<\span><span style=\"color:#999999;\">，否则请更换<\span>
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
      })
    }
  }
}