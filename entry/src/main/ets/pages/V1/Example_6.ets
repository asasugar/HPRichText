import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <a href="http://www.baidu.com">a标签</a>
    <span onClick="handleSpanClick">我是span点击</span>
    <img onClick="handleImgClick" src="https://att2.citysbs.com/jiaxing/2024/03/22/14/middle_2700x3012-143517_v3_17451711089318007_c776635789c2912a64c34bfdc0d7d516.jpg">
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
          console.log('点击：', JSON.stringify(e))
          return e;
        }
      })
    }
  }
}