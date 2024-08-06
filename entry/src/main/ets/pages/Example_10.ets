import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    您好, 现在会员促销期间<font color='red'>打6折</font>哟~错过<font color='red'>时间</font>恢复原价哈!
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