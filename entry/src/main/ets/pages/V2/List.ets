import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';

@Entry
@Component
export default struct Index {
  @State arr: RichTextOptionModelV2[] = []

  // 模拟请求接口数据
  aboutToAppear(): void {
    for (let i = 0; i < 40; i++) {
      let o = new RichTextOptionModelV2();
      o.richTextOption.content =
        `<font style='font-size:18px;'>南京 ${i} 雨花台 → 淮北 相山</font> <img src=\"https://imagecdn.ymm56.com/ymmfile/static/image/match/render/carpoolingImg3xV5.png\" height='18' width='34'/> <font color='#666666' style='font-size:16px;'>4.2米<font color='#CCCCCC'> | </font>高栏<font color='#CCCCCC'> | </font>2吨</font> <font color='#999999' style='font-size:15px;'>衣服 纸箱 <font color='#FF7000'>今天装货</font> 一装一卸</font> <font color='#999999' style='font-size:12px;'>交易334</font>`;
      o.needScroll = false;
      this.arr.push(o);
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