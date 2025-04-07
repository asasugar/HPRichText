import { HPRichTextV2, RichTextOptionModelV2 } from '@ohasasugar/hp-richtext';
import { imgUrl } from '../constant';

@Entry
@Component
struct Index {
  richTextModel: RichTextOptionModelV2 = new RichTextOptionModelV2();

  aboutToAppear() {
    this.richTextModel.richTextOption = {
      content: `
      <h1>h1标签</h1>
      <h2>h2标签</h2>
      <h3>h3标签</h3>
      <h4>h4标签</h4>
      <h5>h5标签</h5>
      <h6>h6标签</h6>
      <div>div标签</div>
      <p>p标签</p>
      <div>
        <font color="red" size="60px">font标签</font>
        <strong>strong标签</strong>
        <b>b标签</b>
        <i>i标签</i>
        <u>u标签</u>
        <s>s标签</s>
        <strike>strike标签</strike>
        <del>del标签</del>
        <big>big标签</big>
        <small>small标签</small>
        <a href="http://www.baidu.com">a标签</a>
        <span>带换行符号或者空格符号的文本：
        【0乳糖，特添优质冷榨生椰浆】使用IIAC大赛金奖咖啡豆，现萃香醇Espresso，遇见鲜椰冷榨生椰浆，椰香浓郁，香甜清爽，带给你不一样的拿铁体验！\r\n\r\n主要原料：浓缩咖啡、冷冻椰浆/椰浆饮品、原味调味糖浆\r\n\r\n图片及包装仅供参考，请以实物为准。\r\n尽快享用风味更佳哦~
        </span>
      </div>
      <input style="color:red" placeholder="请输入..." type="number" maxlength="2" value="我是input标签"/>
      <textarea rows="10" cols="30">
        我是一个文本框
      </textarea>
      <p style="margin: 10px;border: 5px solid #000;">带实线边框样式的</p>
      <p style="margin: 10px;border: 5px dashed #000;">带虚线边框样式的</p>
      <p style="margin: 10px;border: 5px dotted #000;">带点状边框样式的</p>
      <h1 style="overflow: hidden;text-overflow:ellipsis;white-space: nowrap;">单行文本显示省略号单行文本显示省略号单行文本显示省略号单行文本显示省略号</h1>
      <h1 style="-webkit-line-clamp: 2;overflow: hidden;text-overflow:ellipsis;white-space: nowrap;">多行文本显示省略号多行文本显示省略号多行文本显示省略号多行文本显示省略号多行文本显示省略号</h1>
      <img width="500px" src="${imgUrl}" />
      <img width="500px" resource="1" src="app.media.icon" />
      <video height="500px" loop muted autoplay src="https://www.w3school.com.cn/i/video/shanghai.mp4" />
    `,
      imageProp: {
        webp: true,
        copyEnable: true
      },
    }
    this.richTextModel.needScroll = true;
    this.richTextModel.onLinkPress = (e) => {
      return e;
    };
    // 增加复制功能
    this.richTextModel.copyEnable = true;
    this.richTextModel.onCopyPress = (e) => {
      console.log('复制的内容', e.text)
    }
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