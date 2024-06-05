import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
      <span style="font-size:12.5px;"><span style="color:#666666;line-height:1.5;"><span style="font-size:12.5px;"><span style="color:#666666;"></span></span></span><span style="color:#666666;line-height:1.5;">【超级0卡糖*·低负担·0咖啡】</span><br />
      <br />
      <span style="color:#666666;line-height:1.5;">不含咖啡的友好小铁</span><br />
      <span style="color:#666666;line-height:1.5;">陪伴午后的闲暇时光</span><br />
      <br />
      <span style="color:#666666;line-height:1.5;">「超级0卡糖*」原创定制</span><br />
      <span style="color:#666666;line-height:1.5;">果味清爽沁甜</span><br />
      <br />
      <span style="color:#666666;line-height:1.5;">感受青提风味在奶香和椰香中游走</span><br />
      <span style="color:#666666;line-height:1.5;">轻盈地，过夏天</span><br />
      <br />
      <span style="color:#666666;line-height:1.5;">*本品使用0卡青提风味饮料浓浆（含赤藓糖醇）</span><br />
      </span>
    `,
    basePixelUnit: 'vp',
    basePixelRatio: 1,
    imageProp: {
      webp: true,
    }
  };

  build() {
    Column() {
      HPRichText({
        richTextOption: $richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          return e;
        }
      })
    }
  }
}