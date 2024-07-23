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
  @State text: string = ''

  build() {
    Column() {
      Text('1').fontSize(80).onClick((event: ClickEvent) => {
        console.log(JSON.stringify(event))
      })
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