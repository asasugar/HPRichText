import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    baseFontSize: $r('app.string.base_font_size'),
    baseFontColor: $r('app.color.base_font_color'),
    content: `
    <span>
    我是 Resource 资源设置的baseFontSize和baseFontColor
    </span>
    `,
  };

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