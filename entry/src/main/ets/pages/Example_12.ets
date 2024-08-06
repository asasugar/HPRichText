import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <a href='https://u.jd.com/R8nDgYF'>点击 </a> 测试连接<a href='https://jingfen.jd.com/item' >点击</a> 测试连接<a href='https://jingfen.jd.com/item.html'>点击</a>
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
          console.log(JSON.stringify(e))
          return e;
        }
      })
    }
  }
}