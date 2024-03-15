import { HPRichText } from '@ohos/HPRichText'

@Entry
@Component
struct Index {
  @State content: string = `
  <h1 style="-webkit-line-clamp: 1;overflow: hidden;text-overflow:ellipsis;white-space: nowrap;border: 20px solid #000;">12211<u>我是下划线标签内容我是下划线标签内容我是下划线标签内容我是下划线标签内容</u><p>我是P标签</p>11111112<u>666</u>77777<p>我是P标签2222</p>11112222<u>gggg</u></h1>
  <button>我是button按11钮<u>aaa</u>bbb<i>eee</i><h1>ccc</h1>ddd<i>eee</i></button>
  <img src=\"https://img.luckincoffeecdn.com/group2/M00/6E/FB/CtwiPGV79U6AeHIIAAl_HDx_vME238.jpg\" alt=\"\" />
  【0乳糖，特添优质冷榨生椰浆】使用IIAC大赛金奖咖啡豆，现萃香醇Espresso，遇见鲜椰冷榨生椰浆，椰香浓郁，香甜清爽，带给你不一样的拿铁体验！\r\n\r\n主要原料：浓缩咖啡、冷冻椰浆/椰浆饮品、原味调味糖浆\r\n\r\n图片及包装仅供参考，请以实物为准。\r\n尽快享用风味更佳哦~
`
  // <img width="800px" style="height:1800px" src="https://img04.luckincoffeecdn.com/group2/M00/C0/86/CtwiPGWOeu2ABX__AAKqV4dfcn4041.png_.webp" />
  // <font color="red">测试font标签</font>
  // <h3 style="text-align: center;text-decoration: underline #0000FF">h3标题3</h3>
  // <a href="www.baidu.com">我是a链接</a>
  // <font color="red" size="5">测试font标签</font>
  // <button disabled>我是button按钮</button>
  // <p style="background-color: #e5e5e5;line-height: 45px;font-size: 35px;text-indent: 2em;">222</p>
  // '<video width="100px" height="200px" loop muted autoplay poster="https://static.luckincoffeecdn.com/mini/images/mp_v2/menu/default-big-img.png" src="http://video2.luckincoffeecdn.com/group1/M00/66/ED/CtwhA2Usnm-ABh3LAQK2rudTyG0222.mp4" />'
  // '<h1 style="text-align: center;"><i>h1斜体21</i></h1>'
  // '<p style="text-align: center;">p常规</p><hr/>' +
  // '<div style="width: 500px;height: 500px;border: 1px solid;margin: 0auto;">' +
  // '<p style="font-size: 35px;text-align: center;font-weight: bold; color: rgb(24,78,228)">字体大小35px,行高45px</p>' +

  build() {
    Scroll() {
      Column() {
        // Image('https://img.luckincoffeecdn.com/group2/M00/6E/FB/CtwiPGV79U6AeHIIAAl_HDx_vME238.jpg')
        //   .width('100vp')
        //   .height('200vp')
        //   .objectFit(ImageFit.Contain)
        //   .matchTextDirection(true)
        // // .autoResize(true)

        // .maxLines(styleObj?.['text-overflow'] === 'ellipsis' ? 1 : styleObj?.['-webkit-line-clamp'] ?? 999999)
        // .textOverflow({
        //   overflow: (styleObj?.['text-overflow'] === 'ellipsis' || styleObj?.['-webkit-line-clamp']) ? TextOverflow.Ellipsis : TextOverflow.None
        // })
        // .textAlign(2)
        Text('dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        HPRichText({ content: this.content })
      }
      .alignItems(HorizontalAlign.Start)
    }
  }
}