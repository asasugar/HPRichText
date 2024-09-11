import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <a href='https://u.jd.com/R8nDgYF' goodsId='0' couponUrl='{}' platformId='2'>点击链接1 </a> 测试链接1<br><a href='https://jingfen.jd.com/item' goodsId='0' couponUrl='{}' platformId='2'>点击链接2 </a> 测试链接2<br>测试链接2<br><a href='https://jingfen.jd.com/item.html' goodsId='0' couponUrl='{}' platformId='2'>购买 </a>
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
          console.log(JSON.stringify(e))
          return e;
        }
      })
    }
  }
}