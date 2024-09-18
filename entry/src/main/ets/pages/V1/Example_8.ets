import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <div>
      <p>我是 P1</p>
      <span>我是span1</span>
      <span>我是span2</span>
      <p>我是 P2</p>
      <span>我是span3</span>
      <span>我是span4</span>
    </div>
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