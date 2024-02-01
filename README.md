# HPRichText

## 原生存在 `RichText` 组件了，为什么还要花费时间做这个事情？


### 1. 支持的属性有限

只支持通用属性中width，height，size，layoutWeight四个属性。由于padding，margin，constraintSize属性使用时与通用属性描述不符，暂不支持。

### 2. 支持的标签有限

h1~h6、p、br、font、hr、image、div、i、u、行内style、style和script

### 3. Web组件消耗资源，重复使用会出现卡顿、滑动响应慢等现象

![20240201102119](https://raw.githubusercontent.com/asasugar/pic-bed/master/imgs/20240201102119.png)


##  `HPRichText` 组件是怎么解决这些问题？

- 解析HTML，生成描述性的JSON
- 递归遍历JSON结构，通过builder装饰器生成对应的鸿蒙基础组件、通过@Extend装饰器扩展组件样式生成对应的鸿蒙样式

基于这种实现的方式，可以支持更多的属性、标签，且遍历的时候只会生成基础组件，不会生成多个Web 组件而导致性能问题（待开发完成验证）