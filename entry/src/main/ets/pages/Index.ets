import { HPRichText } from '@ohos/HPRichText'

@Entry
@Component
struct Index {
  @State content: string = `<h1 class=test style="text-align: center;text-decoration: underline #0000FF">h1下划线<u>我是下划线标签内容</u></h1>
<button disabled>我是button按钮</button>
<h3 style="text-align: center;text-decoration: underline #0000FF">h3标题3</h3>
`
  // <a style="font-size: 60px;border: 10px dashed #0000FF;width: 600px" href="www.baidu.com">我是a链接</a>
  // <button disabled>我是button按钮</button>
  // <img src="https://img04.luckincoffeecdn.com/group2/M00/C0/86/CtwiPGWOeu2ABX__AAKqV4dfcn4041.png_.webp" />
  // <p style="background-color: #e5e5e5;line-height: 45px;font-size: 35px;text-indent: 2em;">222</p>
  // '<video width="100px" height="200px" loop muted autoplay poster="https://static.luckincoffeecdn.com/mini/images/mp_v2/menu/default-big-img.png" src="http://video2.luckincoffeecdn.com/group1/M00/66/ED/CtwhA2Usnm-ABh3LAQK2rudTyG0222.mp4" />'
  // '<h1 style="text-align: center;"><i>h1斜体21</i></h1>'
  // '<p style="text-align: center;">p常规</p><hr/>' +
  // '<div style="width: 500px;height: 500px;border: 1px solid;margin: 0auto;">' +
  // '<p style="font-size: 35px;text-align: center;font-weight: bold; color: rgb(24,78,228)">字体大小35px,行高45px</p>' +

  build() {
    Row() {
      HPRichText({ content: this.content })
    }
  }
}