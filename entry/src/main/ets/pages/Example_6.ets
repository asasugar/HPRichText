import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <a href="http://www.baidu.com">a标签</a>
    <span onClick="handleSpanClick">我是span点击</span>
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
          console.log('6', JSON.stringify(e))
          return e;
        }
      })
    }
  }
}