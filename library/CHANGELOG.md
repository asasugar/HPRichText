# Changelog

### [v3.0.4](https://github.com/asasugar/HPRichText/releases/tag/v3.0.4) (2024-11-01)

### Bug Fixes

- 🐛
  修复html非法使用style script标签渲染问题 [(#77)](https://github.com/asasugar/HPRichText/issues/77)
  ([e0a66b7](https://github.com/asasugar/HPRichText/commit/e0a66b714d0adda9b2d4a098b9c0c5bc0ea8211c))

### Features

- 🎸
  支持img设置margin [(#71)](https://github.com/asasugar/HPRichText/issues/71)
  ([8a9348e](https://github.com/asasugar/HPRichText/commit/8a9348ec5343979e57627dcd2650cf17e2d50bf7))

### [v3.0.3](https://github.com/asasugar/HPRichText/releases/tag/v3.0.3) (2024-10-23)

### Bug Fixes

- 🐛
  兼容内联图片展示 [(#68)](https://github.com/asasugar/HPRichText/issues/68)
  ([25bd470](https://github.com/asasugar/HPRichText/commit/25bd470e5e2b9f70f3eaf4bab9a1d4f094d29f0e))

- 🐛
  优化正则修复px2Any方法将文本也转化的问题
  ([68bb9ed](https://github.com/asasugar/HPRichText/commit/68bb9ed8eb732c816d0a29d9010fc3fbc15efc76))

### Features

- 🎸
  html字符串img支持本地resource资源链接 [(#67)](https://github.com/asasugar/HPRichText/issues/67)
  ([dfe71ff](https://github.com/asasugar/HPRichText/commit/dfe71ff838f176a621ef8feea3d615d12043e756))

### [v3.0.2](https://github.com/asasugar/HPRichText/releases/tag/v3.0.2) (2024-09-20)

### Bug Fixes

- 🐛
  更多标签继承baseFontSize等基础样式属性
  ([d9f01df](https://github.com/asasugar/HPRichText/commit/d9f01dfbec2004b2945bbfb7306706127c1bf8c4))

### [v3.0.1](https://github.com/asasugar/HPRichText/releases/tag/v3.0.1) (2024-09-20)

### Refactor

- 💡
  优化组件&样式
  [#63](https://github.com/asasugar/HPRichText/issues/63)([93928c8](https://github.com/asasugar/HPRichText/commit/93928c8815f3eff65082ab82351ae5beb4a2ad2b))

### [v3.0.0](https://github.com/asasugar/HPRichText/releases/tag/v3.0.0) (2024-09-18)

### Features

- 🎸
  升级 @ComponentV2装饰器
  组件 [#60](https://github.com/asasugar/HPRichText/issues/60)([be583b6](https://github.com/asasugar/HPRichText/commit/be583b60c0ecf4a88b607dbd96f6cfca899c4e1d))

### [v2.2.6](https://github.com/asasugar/HPRichText/releases/tag/v2.2.6) (2024-09-14)

### Features

* 🎸
  更新 API12
  SDK重新编译发包 ([3f90518](https://github.com/asasugar/HPRichText/commit/3f905189faa9307aa5ef82e1316918350e9b3fec))

### [v2.2.5](https://github.com/asasugar/HPRichText/releases/tag/v2.2.5) (2024-09-14)

### Features

* 🎸
  新增 ObservedHPRichText
  组件支持动态生成richTextOption参数 ([0d35d86](https://github.com/asasugar/HPRichText/commit/0d35d862d3d5610285d632c9aeddbb41f9b6a7b4))

### [v2.2.4](https://github.com/asasugar/HPRichText/releases/tag/v2.2.4) (2024-09-11)

### Features

* 🎸
  img跟video标签增加点击事件支持&回调参数调整 ([740e5bf](https://github.com/asasugar/HPRichText/commit/740e5bfed11dd6879e09839dd04b724cf551b3c9))
* 🎸
  baseFontSize、baseFontColor属性支持Resource类型暴露css中utils方法 ([655fee6](https://github.com/asasugar/HPRichText/commit/655fee65fba77b48c2f28b5631bff318d32eef81))

### Bug Fixes

* 🐛
  修复嵌套text导致的渲染异常问题 [(#55)](https://github.com/asasugar/HPRichText/issues/55) ([bc83328](https://github.com/asasugar/HPRichText/commit/bc83328588268e13ef8cf5282fcd83e57d13423c))

* 🐛
  修复嵌套子节点样式丢失问题 [(#52)](https://github.com/asasugar/HPRichText/issues/52) ([429222e](https://github.com/asasugar/HPRichText/commit/429222eaa2d4a28909ffca4e7efdade1ca72f62b))

### [v2.2.3](https://github.com/asasugar/HPRichText/releases/tag/v2.2.3) (2024-08-09)

### Bug Fixes

* 🐛
  push子节点默认样式丢失问题 [(#47)](https://github.com/asasugar/HPRichText/issues/47) ([0435bb8](https://github.com/asasugar/HPRichText/commit/0435bb869427afe4765462239153ab832dd1a503))

### [v2.2.2](https://github.com/asasugar/HPRichText/releases/tag/v2.2.2) (2024-08-07)

### Features

* 🎸
  导出HTMLParser类 [(#40)](https://github.com/asasugar/HPRichText/issues/40) ([b6cad1d](https://github.com/asasugar/HPRichText/commit/b6cad1dcbc065ee9e9ef20c02c90490b9ec63d9d))

### Bug Fixes

* 🐛
  修复span标签设置baseFontSize失效问题 [(#42)](https://github.com/asasugar/HPRichText/issues/42) ([5282277](https://github.com/asasugar/HPRichText/commit/52822771613dbbf02fb1515bae9358e3485ed3d6))

### [v2.2.1](https://github.com/asasugar/HPRichText/releases/tag/v2.2.1) (2024-08-06)

### Bug Fixes

* 🐛
  修复ts报错 [(#41)](https://github.com/asasugar/HPRichText/issues/41) ([8209144](https://github.com/asasugar/HPRichText/commit/8209144ceaa430384aeadedf9be33cf6db58e576))

* 🐛
  修复样式继承覆盖问题 [(#38)](https://github.com/asasugar/HPRichText/issues/38) ([fc64343](https://github.com/asasugar/HPRichText/commit/fc643432f137ecbe5a3e63fb9e6f4517df7d868b))

* 🐛
  修复text-align属性不生效问题 [(#37)](https://github.com/asasugar/HPRichText/issues/37) ([11472b2](https://github.com/asasugar/HPRichText/commit/11472b23cacfd636f1510e55f5481abfd2b151ac))

* 🐛
  修复ts报错 [(#36)](https://github.com/asasugar/HPRichText/issues/36) ([8ad85b8](https://github.com/asasugar/HPRichText/commit/8ad85b85b542a69a5d3d5099bc249805cb11a00f))

### Features

* 🎸
  新增css颜色样式非十六进制时的匹配 [(#32)](https://github.com/asasugar/HPRichText/issues/32) ([54a8841](https://github.com/asasugar/HPRichText/commit/54a884127d1cae615e254cdf1e20fbc2afebc199))

### [v2.2.0](https://github.com/asasugar/HPRichText/releases/tag/v2.2.0) (2024-08-01)

### Refactor

* 💡
  遍历算法优化,修复已知部分场景渲染层级异常问题 [(#31)](https://github.com/asasugar/HPRichText/issues/31) ([9447cbc](https://github.com/asasugar/HPRichText/commit/9447cbcc8f0bdf1a263756ea137b5affbcc21989))

### Bug Fixes

* 🐛
  修复字体加粗渲染异常问题 [(#33)](https://github.com/asasugar/HPRichText/issues/33)、[(#34)](https://github.com/asasugar/HPRichText/issues/34) ([dc2c32b](https://github.com/asasugar/HPRichText/commit/dc2c32b4f53de915a17269fde0945828632bc27b))

* 🐛
  支持\t转义符号 [(#28)](https://github.com/asasugar/HPRichText/issues/28) ([c05b513](https://github.com/asasugar/HPRichText/commit/c05b513d98803f2530636876d14efb8d5e4c18d2))

### [v2.1.0](https://github.com/asasugar/HPRichText/releases/tag/v2.1.0) (2024-07-23)

### Features

* 🎸
  开放点击事件 [(#26)](https://github.com/asasugar/HPRichText/issues/26) ([1e955d3](https://github.com/asasugar/HPRichText/commit/1e955d3565b68097ab8bb8b9f38863d0306c5f41))

### [v2.0.1](https://github.com/asasugar/HPRichText/releases/tag/v2.0.1) (2024-07-15)

### Features

* 🎸
  增加writing-mode属性的支持 [(#25)](https://github.com/asasugar/HPRichText/issues/25) ([a9dcbb2](https://github.com/asasugar/HPRichText/commit/a9dcbb28c60f94ca096c809908dba8cf17d91f0f))

### Bug Fixes

* 🐛
  Update README.md && export ts
  types [(#24)](https://github.com/asasugar/HPRichText/issues/24) ([fbe1218](https://github.com/asasugar/HPRichText/commit/fbe121874b42ea986b82e8ca5b6d3a6257177e19))

### [v2.0.0](https://github.com/asasugar/HPRichText/releases/tag/v2.0.0) (2024-07-08)

### Features

* 🎸
  一体化工程迁移NEXT Developer
  Beta1版本 ([61b7628](https://github.com/asasugar/HPRichText/commit/61b7628ae113bf8e04d6cc3a131dd5cef646fbfa))

### [v1.0.8](https://github.com/asasugar/HPRichText/releases/tag/v1.0.8) (2024-06-12)

### Features

* 🎸
  lineHeight配置纯数字时候样式调整 ([ce785d8](https://github.com/asasugar/HPRichText/commit/ce785d89ba89c8b17cb56e839d7885f93b8973f6))

### [v1.0.7](https://github.com/asasugar/HPRichText/releases/tag/v1.0.7) (2024-06-05)

### Features

* 🎸
  新增basePixelRatio和basePixelUnit [(#14)](https://github.com/asasugar/HPRichText/issues/14) ([065e045](https://github.com/asasugar/HPRichText/commit/065e045931955239fc34c93c3a81676a5213d059))

### [v1.0.6](https://github.com/asasugar/HPRichText/releases/tag/v1.0.6) (2024-05-17)

### Features

* 🎸
  增加baseFontColor配置 [(#11)](https://github.com/asasugar/HPRichText/issues/11) ([170c6bc](https://github.com/asasugar/HPRichText/commit/170c6bcd99d7762e1d4146ca9251e191f1e4a669))

### [v1.0.5](https://github.com/asasugar/HPRichText/releases/tag/v1.0.5) (2024-05-13)

### Bug Fixes

* 🐛
  修复
  ForEach循环key更新问题 [(#10)](https://github.com/asasugar/HPRichText/issues/10) ([e962cba](https://github.com/asasugar/HPRichText/commit/e962cba710a15e12ec406ff0140bedeec5bc8e85))

* 🐛
  修复修改baseFontSize不生效问题 [(#9)](https://github.com/asasugar/HPRichText/issues/9) ([087f1ad](https://github.com/asasugar/HPRichText/commit/087f1adb4bb8d5ee1e32817abfa1df9c31464f60))

### [v1.0.4](https://github.com/asasugar/HPRichText/releases/tag/v1.0.4) (2024-04-30)

### Bug Fixes

* 🐛
  修复富文本组件参数更新重新渲染问题 [(#7)](https://github.com/asasugar/HPRichText/issues/7) ([05bd28e](https://github.com/asasugar/HPRichText/commit/05bd28e95625ae3b0120879bf28814761e19b17c))

### [v1.0.3](https://github.com/asasugar/HPRichText/releases/tag/v1.0.3) (2024-04-23)

### Features

* 🎸
  added example ([2406cf4](https://github.com/asasugar/HPRichText/commit/2406cf4ec03850064c9522f12f4fb88c271addb5))

### Bug Fixes

* 🐛 遍历算法优化  ([7b9d5b5](https://github.com/asasugar/HPRichText/commit/7b9d5b5cdd21c5f146aa3d3d4f0f90b820c47577))

* 🐛
  增加baseFontSize参数 [(#6)](https://github.com/asasugar/HPRichText/issues/6) ([01db736](https://github.com/asasugar/HPRichText/commit/01db7366bf6e52730fc4295d40e3665a672a3ed5))

### [v1.0.2](https://github.com/asasugar/HPRichText/releases/tag/v1.0.2) (2024-04-07)

### Bug Fixes

* 🐛
  降低遍历复杂度 [(#2)](https://github.com/asasugar/HPRichText/issues/2) ([8e422a2](https://github.com/asasugar/HPRichText/commit/8e422a2e2a30c42f050dcd6ed2455f3af579ea3e))

### [v1.0.1](https://github.com/asasugar/HPRichText/releases/tag/v1.0.1) (2024-03-26)

### Features

* 🎸
  新增a标签onLinkPress点击事件回调 ([780e4ae](https://github.com/asasugar/HPRichText/commit/780e4aec1138a64f87e442596a82759e9df27609))

### [v1.0.0-next](https://github.com/asasugar/HPRichText/releases/tag/v1.0.0-next) (2024-03-20)

### Features

* 🎸
  鸿蒙富文本组件v2-基于Harmony NEXT
  4.1版本 ([7a42f68](https://github.com/asasugar/HPRichText/commit/7a42f68f939a3ffcc31f5fce951137c86ae4240f))

### [v1.0.0](https://github.com/asasugar/HPRichText/releases/tag/v1.0.0) (2024-03-18)

### Features

* 🎸
  鸿蒙富文本组件v1-基于Harmony
  3.1版本 ([934a16a](https://github.com/asasugar/HPRichText/commit/934a16a4b2269ac58ea819bdda6cef502c9c1b9c))
