import { ObservedHPRichText, RichTextOptionModel } from '@ohasasugar/hp-richtext';


@Entry
@Component
struct Index {
  @State arr: RichTextOptionModel[] = []

  // 模拟请求接口数据
  aboutToAppear(): void {
    for (let i = 0; i < 4; i++) {
      let o = new RichTextOptionModel();
      o.content = `<span style="color: #fff">我是 ObservedHPRichText 组件${i}</span>`;
      this.arr.push(o)
    }
  }

  build() {
    Column() {
      List({ space: 10 }) {
        ForEach(this.arr, (item: RichTextOptionModel) => {
          ListItem() {
            ObservedHPRichText({
              observedRichTextOption: item,
              needScroll: true,
              onLinkPress: (e) => {
                console.log(JSON.stringify(e))
                return e;
              }
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