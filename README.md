# hp-richtext - 鸿蒙高性能富文本组件

## 简介

### 原生存在 `RichText` 组件了，为什么还要花费时间做这个事情？

#### 1. 支持的属性有限

只支持通用属性中width，height，size，layoutWeight四个属性。由于padding，margin，constraintSize属性使用时与通用属性描述不符，暂不支持。

#### 2. 支持的标签有限

h1~h6、p、br、font、hr、image、div、i、u、行内style、style和script

#### 3. Web组件消耗资源，重复使用会出现卡顿、滑动响应慢等现象

![20240201102119](https://raw.githubusercontent.com/asasugar/pic-bed/master/imgs/20240201102119.png)

### 4. `hp-richtext` 组件是怎么解决这些问题？

- 解析HTML，生成描述性的JSON
- 递归遍历JSON结构，通过builder装饰器生成对应的鸿蒙基础组件、通过@Extend装饰器扩展组件样式生成对应的鸿蒙样式

基于这种实现的方式，可以支持更多的属性、标签，且遍历的时候只会生成基础组件，不会生成多个Web 组件而导致性能问题（待开发完成验证）

## 需要权限

如果img、video 引用网络资源需要
```
ohos.permission.INTERNET
```

## 下载安装

```bish
ohpm install @ohasasugar/hp-richtext
```

## 使用示例

```ets
import { HPRichText } from '@ohasasugar/hp-richtext';
@Component
struct Index {
  @State content: string = `
  <h1 style="text-indent: 200px">h1标签</h1>
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
    <input style="color:red" placeholder="请输入..." type="number" maxlength="2" value="我是input标签"/>
    <textarea rows="10" cols="30">
      我是一个文本框
    </textarea>
    <span>
    带换行符号或者空格符号的文本：
    【0乳糖，特添优质冷榨生椰浆】使用IIAC大赛金奖咖啡豆，现萃香醇Espresso，遇见鲜椰冷榨生椰浆，椰香浓郁，香甜清爽，带给你不一样的拿铁体验！\r\n\r\n主要原料：浓缩咖啡、冷冻椰浆/椰浆饮品、原味调味糖浆\r\n\r\n图片及包装仅供参考，请以实物为准。\r\n尽快享用风味更佳哦~
    </span>
  </div>
  <p style="margin: 10px;border: 5px solid #000;">带边框样式的</p>
  <p style="margin: 10px;border: 5px dashed #000;">带边框样式的</p>
  <h1 style="overflow: hidden;text-overflow:ellipsis;white-space: nowrap;">单行文本显示省略号单行文本显示省略号</h1>
  <h1 style="-webkit-line-clamp: 2;overflow: hidden;text-overflow:ellipsis;white-space: nowrap;">多行文本显示省略号多行文本显示省略号多行文本显示省略号</h1>
  <img src="https://img04.luckincoffeecdn.com/group2/M00/C0/86/CtwiPGWOeu2ABX__AAKqV4dfcn4041.png_.webp"/>
  <video height="500px" loop muted autoplay src="http://video2.luckincoffeecdn.com/group1/M00/66/ED/CtwhA2Usnm-ABh3LAQK2rudTyG0222.mp4" />
`

  build() {
    Column() {
      HPRichText({ content: this.content })
    }
  }
}
```

## 注意点

- text-overflow只对一级块级标签或者全都行内子标签生效，嵌套块级标签需要换行，即使用Text重新生成一个文本，导致最外层的Text设置的多行省略文本会被嵌套的块级标签分割开
- 非文本标签，如: `img` 、 `input` 、 `textarea` 在组件中会当`块级标签`渲染
- `table`、`li`暂不支持
- `ul`、`ol` 渲染为带初始样式普通块级标签
- `style` 和 `script` 外部标签暂不支持，`行内style` 支持

## 支持的标签列表

- h1~h6
- div
- p
- span
- b/strong
- big
- small
- s/strike/del
- a
- img
- video
- code
- pre
- tt/kbd/samp
- i/em/var/address/cite
- s
- u
- hide
- ol/ul
- input
- textarea

## 效果展示

![20240318172402](https://raw.githubusercontent.com/asasugar/pic-bed/master/imgs/20240318172402.png)

![20240318172501](https://raw.githubusercontent.com/asasugar/pic-bed/master/imgs/20240318172501.png)