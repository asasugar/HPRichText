export interface IStyledStringEmojiInfo{
   tag:string,//表情名字，比如[#大笑]
   path:string,//表情路径 比如'/emoji/DaXiao.png' 需要注意的是，放到raw路径
}

export interface IStyledStringEmojiMargin{
   left:number,
   right:number,
   bottom:number,
   top:number
}

export interface IStyledStringEmojiConfig{
   size:number,
   margin: IStyledStringEmojiMargin
}

export interface IStyledStringConfig{
   fontSize?:number;
   fontColor?:string;
   lineSpacing?:number;
   emojiConfig?:IStyledStringEmojiConfig
}

export interface IRichTextParseResult{
   styledString:MutableStyledString,
   needRenderFullWidth:boolean
}

//自定义span
export class BackedStringSpan extends CustomSpan{
   backedString:string = '';
   constructor(backed:string) {
      super()
      this.backedString = backed
   }

   onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {
      return{width:0,height:0}
   }

   onDraw(context: DrawContext, drawInfo: CustomSpanDrawInfo): void {
      //子类实现
   }
}