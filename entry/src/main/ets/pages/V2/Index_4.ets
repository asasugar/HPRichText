import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State arr: RichTextOptionModelV2[] = []

  // 模拟请求接口数据
  aboutToAppear(): void {
    for (let i = 0; i < 4; i++) {
      let o = new RichTextOptionModelV2();
      o.richTextOption.content = `<span style="color: #fff">我是 HPRichTextV2 组件${i}</span>`;
      this.arr.push(o)
    }
  }

  build() {
    Column() {
      List({ space: 10 }) {
        ForEach(this.arr, (item: RichTextOptionModelV2) => {
          ListItem() {
            HPRichTextV2({
              richTextModel: item
            })
              .width('100%')
              .height(100)
              .borderRadius(10)
              .backgroundColor(0x007DFF)
          }
        }, (item: number) => JSON.stringify(item))
      }
    }
    .padding(12)
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}