import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

interface RichBuilder {
  richTextOption: RichTextOption
}

@Entry
@Component
struct Index {
  @State richTextOption1: RichTextOption = {
    content: '',
    imageProp: {
      webp: true,
    }
  };
  @State richTextOption2: RichTextOption = {
    content: '',
    imageProp: {
      webp: true,
    }
  };

  @Builder
  HPRichTextBuilder($$: RichBuilder) {
    if ($$.richTextOption.content) {
      HPRichText({
        richTextOption: $$.richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          return e;
        }
      })
    }
  }

  build() {
    Column() {
      Button('模拟请求接口 1，然后渲染富文本 1').onClick(() => {
        this.richTextOption1.content = '我是富文本 1'
      })
      Button('模拟请求接口 2，然后渲染富文本 2').onClick(() => {
        this.richTextOption2.content = '我是富文本 2'
      })
      this.HPRichTextBuilder({ richTextOption: this.richTextOption1 });
      this.HPRichTextBuilder({ richTextOption: this.richTextOption2 });
    }
  }
}