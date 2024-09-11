import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    baseFontSize: 30,
    baseFontColor: "#99000000",
    content: `
    <span style='text-align:center;'>
    我遵守以下规则:<br/>1.内容积极向上<br/>2.图片健康非黄<br/>3.音视频不侵权<br/><font color='red'>我保证: 将要发布的作品没有侵犯版权等违法行为, 否则后果自负!</font>
    </span>
    `,
  };
  @State text: string = ''
  @State handlePopup: boolean = false
  @State customPopup: boolean = false

  build() {
    Column() {
      HPRichText({
        richTextOption: $richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          console.log(JSON.stringify(e))
          return e;
        }
      })
    }
  }
}