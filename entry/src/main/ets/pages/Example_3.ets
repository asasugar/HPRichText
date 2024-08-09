import { HPRichText, RichTextOption, StyledStringParser } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `这个文本包含<span>span</span>文本`,
    imageProp: {
      webp: true,
    }
  };

  textController:TextController = new TextController()
  build() {
    // Column() {
    //   HPRichText({
    //     richTextOption: $richTextOption,
    //     needScroll: true,
    //     onLinkPress: (e) => {
    //       return e;
    //     }
    //   })
    // }
    Text(undefined,{controller:this.textController})
      .onAttach(()=>{
        let res = new StyledStringParser(this.richTextOption.content).getResult()
        this.textController.setStyledString(res.styledString)
      })
  }
}