import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

// import { imgUrl } from '../constant';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  // <img width="500px" src="${imgUrl}" />
  aboutToAppear() {
    this.richTextModel.richTextOption = {
      content: `
      <div>我是带<span style="background-color: red">背景色的span标签</span>111<p>222</p></div>
    `,
      imageProp: {
        webp: true,
      },
    }
    this.richTextModel.needScroll = true;
    this.richTextModel.onLinkPress = (e) => {
      return e;
    };
  }

  build() {
    Column() {
      Button('改变数据').onClick(() => {
        this.richTextModel.richTextOption = {
          baseFontSize: 50,
          baseFontColor: '#ecd88d',
          content: '我是改变之后的数据，如通过ajax请求返回的数据'
        }
      })
      HPRichTextV2({
        richTextModel: this.richTextModel
      })
    }
  }
}