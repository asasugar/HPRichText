import { image } from '@kit.ImageKit';
import { drawing } from '@kit.ArkGraphics2D';
import { BackedStringSpan, IStyledStringEmojiConfig } from './IStyledStringProtocols';
import { hilog } from '@kit.PerformanceAnalysisKit';


export class EmojiIconSpan extends BackedStringSpan {
   iconPath:string;
   pixelMap?:image.PixelMap;
   layoutConfig:IStyledStringEmojiConfig = {
      size:16,
      margin:{
         left:3,
         bottom:3,
         top:3,
         right:3
      }
   }
   public static creatStyledString(text:string,iconPath:string,layoutConfig?:IStyledStringEmojiConfig):MutableStyledString{
      let span:CustomSpan = new EmojiIconSpan(text,iconPath,layoutConfig);
      let styledString = new MutableStyledString(span);
      return styledString
   }

   constructor(text:string,iconPath:string,emojiConfig?:IStyledStringEmojiConfig) {
      super(text)
      if (emojiConfig) {
         this.layoutConfig = emojiConfig
      }
      this.iconPath = iconPath;
   }

   onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {
      let w = this.layoutConfig.size + this.layoutConfig.margin.left + this.layoutConfig.margin.right;
      let h = this.layoutConfig.size + this.layoutConfig.margin.top + this.layoutConfig.margin.bottom;
      let met:CustomSpanMetrics = { width: w, height: h };
      return met
   }

   onDraw(context: DrawContext, options: CustomSpanDrawInfo) {
      try {
         const abilityContext : Context = getContext(this);
         const resourceMgr = abilityContext.resourceManager;
         let rawFileDescriptor = resourceMgr.getRawFdSync(this.iconPath)
         let imageSource = image.createImageSource(rawFileDescriptor)
         this.pixelMap = imageSource.createPixelMapSync()
         let drawingOptions = new drawing.SamplingOptions(drawing.FilterMode.FILTER_MODE_NEAREST);
         const canvas = context.canvas;
         let left = options.x + this.layoutConfig.margin.left
         let top = options.lineTop+this.layoutConfig.margin.top
         canvas.drawImage(this.pixelMap,left,top,drawingOptions)
         imageSource.release()
      } catch (e) {
         hilog.debug(-1,'自定义Span渲染失败',e)
      }
   }
}




// mark ----- 根据url和宽高初始化一个styledString

export class ImageCustomSpan extends CustomSpan{
   private pixelMap?:image.PixelMap;
   private url:string;
   width:number = 0;
   height:number = 0;
   public static creatStyledString(w:number,h:number,url:string):MutableStyledString{
      let span:CustomSpan = new ImageCustomSpan(w,h,url);
      let styledString = new MutableStyledString(span);
      return styledString
   }

   constructor(w:number,h:number,url:string) {
      super();
      this.width = w;
      this.height = h;
      this.url = url;
   }

   onMeasure(measureInfo: CustomSpanMeasureInfo): CustomSpanMetrics {
      return {width:this.width,height:this.height}
   }

   async onDraw(context: DrawContext, options: CustomSpanDrawInfo){
      //todo: 华为对异步渲染的支持有点问题。这里尝试用ImageKnife异步拿图片后渲染，结果并不如意。已经给华为提issue看看他们怎么说
   }
}