import type { RichTextOption } from '@ohasasugar/hp-richtext';
import { HPRichText } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
      <span style="writing-mode: vertical-lr; ">我是一个为竖直方向的例子：本文档适用于应用开发的初学者。通过构建一个简单的具有页面跳转/返回功能的应用，快速了解工程目录的主要文件，熟悉应用开发流程。</span>
    `,
    basePixelUnit: 'vp',
    basePixelRatio: 1,
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