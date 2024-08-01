import { HPRichText, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
    <p><p class="MsoNormal" style="text-indent:21pt;"><span style="font-family:宋体;font-size:14pt;font-weight:normal;">\t\t\t反馈回来发货了护林防火撒flash发拉萨<span> 32</span><span>减肥啦设计费拉数据发啦</span><span>21983u198319</span><span>放假啊射流风机阿拉善飞机啊失蜡法积极我</span><span>APP</span><span>巨垃圾管理；加了阿济格刚才那，把你拉许嵩 </span></span><span style="font-family:宋体;font-size:14pt;font-weight:normal;"></span>	</p><p class="MsoNormal" style="text-indent:21pt;"><span style="font-family:宋体;font-size:14pt;font-weight:normal;">\t\t\t你电脑飞鹅岭分动箱色<span>24</span><span>手打挖方</span><span>2の342242</span><span>打撒福娃；防磨瓦</span></span><span style="font-family:宋体;font-size:14pt;font-weight:normal;"></span> </p></p>
       `,
    imageProp: {
      webp: true,
    }
  };
  @State text: string = ''

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