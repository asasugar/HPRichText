
import { LengthMetrics } from '@kit.ArkUI';
import { ArtStyleObject, HtmlParserResult, NodeInfo } from '../common/types';
import { hrefTag } from '../common/utils/html';
import HTMLParser from '../common/utils/html/html-parser';
import { NodesBuilderOptions, RichTextOption, TextBuilderOptions } from '../components/hprichtext';
import { EmojiIconSpan, ImageCustomSpan } from './EmojiSpan';
import { BackedStringSpan,
   IRichTextParseResult,
   IStyledStringConfig, IStyledStringEmojiConfig,
   IStyledStringEmojiInfo } from './IStyledStringProtocols';

class StyledStringParseConfig{
   fontSize:number = 16;
   fontColor:string = '#000000';
   lineSpacing:number = 0;
   emojiConfig:IStyledStringEmojiConfig = {
      size:16,
      margin:{
         top:3,
         bottom:3,
         right:3,
         left:3
      }
   }
   constructor(config?:IStyledStringConfig) {
      if (config?.fontSize) {
         this.fontSize = config?.fontSize
      }
      if (config?.fontColor) {
         this.fontColor = config?.fontColor
      }
      if (config?.lineSpacing) {
         this.lineSpacing = config.lineSpacing
      }
      if (config?.emojiConfig) {
         this.emojiConfig = config.emojiConfig
      }
   }
}

export class StyledStringParser{
   //表情map  在合适的时候set进来
   static emojiMap:Map<string,IStyledStringEmojiInfo>;
   //原始文本
   source:string;
   //将[#表情]替换为<emj tag="xx">xx<emj>后的文本。方便统一解析
   private fixedSource:string;
   //配置
   config:StyledStringParseConfig = new StyledStringParseConfig()
   //点击事件 仅对hrefTag中的生肖
   tapAction?:((href:string,subStyledText:StyledString)=>void);
   //是否要渲染全部的宽度,当文本对齐有居中/居右的时候这个为true,请在这种情况下不要让Text/RichEditor等控件自适应宽度。
   shouldRenderFullWidth:boolean = false;
   //格式化后的文本
   richText:MutableStyledString = new MutableStyledString('');
   //解析结果
   htmlJson: HtmlParserResult = {
      nodes:[],
      source:'',
   };
   constructor(source:string,config?:IStyledStringConfig) {
      this.source = source;
      this.fixedSource = replaceEmojiTagToHtmlStyle(this.source);
      if (config) this.config = new StyledStringParseConfig(config);
      if (!this.fixedSource.startsWith('<p>') && !this.fixedSource.endsWith('</p>')) {
         this.fixedSource = '<p>'+this.fixedSource+'</p>'
      }
      this.parseHTML();
      if (this.htmlJson.nodes.length) {
         //如果解析出节点，则拼装
         this.buildStyledStringWithNodes({ nodes: this.htmlJson.nodes });
      }else{
         //否则直接根据当前config new一个富文本
         this.buildStyledStringFromSourceText();
      }
   }

   getResult():IRichTextParseResult{
      return{
         styledString:this.richText,
         needRenderFullWidth:this.shouldRenderFullWidth
      }
   }

   parseHTML(){
      const config:RichTextOption = {
         content:this.fixedSource,
         baseFontSize:this.config.fontSize,
         baseFontColor:this.config.fontColor
      }
      const htmlParser = new HTMLParser(config);
      this.htmlJson = htmlParser.html2json();
   }

   //根据当前source和config直接生成一个富文本
   buildStyledStringFromSourceText(){
      let richText:MutableStyledString = new MutableStyledString(this.source);
      const styles:SpanStyle = {
         start:0,
         length:richText.length,
         styledKey:StyledStringKey.FONT,
         styledValue:{
            fontSize:this.config.fontSize,
            fontColor:this.config.fontColor,
         }
      }
      richText.setStyle(styles);
      this.richText.appendStyledString(richText);
   }

   buildStyledStringWithNodes(opt:NodesBuilderOptions){
      if (!opt.nodes?.length) {
         return
      }
      for (const item of opt.nodes) {
         // 标签
         if (item.node === 'element') {
            if(item.tag === 'emj'){
               //跨声emoji
               this.appendEmojiStyledString(item)
            }else if (item.tag === 'img') {
               //图文混排
               this.appendImageStyledString(item);
            } else {
               this.buildStyledStringWithNodes({
                  nodes: item.nodes,
                  parentNode: item
               })
            }
         } else if (item.node === 'text') {
            //text
            this.appendTextStyledString({ node: item,index:0, parentNode: opt.parentNode });
         }
      }
   }

   labelLevelNodeAudoFixNewLine(node?:NodeInfo){
      if (!node?.tag) {
         return
      }
      if (node.fixedNewLine) {
         return
      }
      if (this.richText.length==0) {
         //首个标签不需要换行 并且标记后续的node也不要换行
         node.fixedNewLine = true
         return
      }
      let fix = ['p','li','ol'].includes(node.tag)
      if (fix) {
         this.richText.appendStyledString(new StyledString('\n'));
         node.fixedNewLine = true
      }
   }

   //循环.nodes找根节点添加 循环直到item.node === 'text'
   labelLevelAppendNode(opt: TextBuilderOptions){
      if (!opt.node) {
         return
      }
      //标签自动添加换行 p、ol、li标签需要新起一行
      this.labelLevelNodeAudoFixNewLine()
      // 若找到块级标签
      if (opt.node.nodes && this.getBlockIndex(opt.node) > -1) {
         // 块级标签不是第一项，则将行内标签元素统一处理
         if (this.getBlockIndex(opt.node) > 0) {
            if (!opt.parentNode) {
               this.buildStyledStringWithNodes({
                  nodes: opt.node.nodes.slice(0, this.getBlockIndex(opt.node)),
                  parentNode: opt.node,
               });
            } else {
               this.buildStyledStringWithNodes({
                  nodes: opt.node.nodes.slice(0, this.getBlockIndex(opt.node)),
                  parentNode: opt.node,
               });
            }
         }
         // 中间一项为单独的块级标签
         if (!opt.parentNode) {
            this.buildStyledStringWithNodes({
               nodes: [opt.node.nodes[this.getBlockIndex(opt.node)]],
               parentNode: opt.node,
            });
         } else {
            this.buildStyledStringWithNodes({
               nodes: [opt.node.nodes[this.getBlockIndex(opt.node)]],
               parentNode: opt.node,
            });
         }

         // 第三项中判断还有剩余元素则递归处理
         // 可能还存在block
         if (opt.node.nodes.length - 1 > this.getBlockIndex(opt.node)) {
            if (!opt.parentNode) {
               this.buildStyledStringWithNodes({
                  nodes: opt.node.nodes.slice(this.getBlockIndex(opt.node) + 1),
                  parentNode: opt.node,
               });
            } else {
               this.buildStyledStringWithNodes({
                  nodes: opt.node.nodes.slice(this.getBlockIndex(opt.node) + 1),
                  parentNode: opt.node,
               });
            }
         }
      } else {
         // 长度为 1 直接渲染，降低复杂度
         if (opt.node.nodes?.length === 1 && opt.node.nodes[0].node === 'text') {
            if (!opt.parentNode) {
               this.appendTextStyledString({ node: opt.node.nodes[0],index:0, parentNode: opt.node })
            } else {
               this.appendTextStyledString({ node: opt.node.nodes[0],index:0, parentNode: opt.node })
            }
         } else {
            if (!opt.parentNode) {
               this.buildStyledStringWithNodes({
                  nodes: opt.node.nodes,
                  parentNode: opt.node,
               });
            } else {
               this.buildStyledStringWithNodes({
                  nodes: opt.node.nodes,
                  parentNode: opt.node,
               });
            }
         }
      }
   }

   //添加富文本
   appendTextStyledString(opt: TextBuilderOptions){
      if (!opt.node.text) {
         return
      }
      if (opt.node.text.startsWith('@') && !opt.node.text.endsWith(' ')) {
         opt.node.text+=' '
      }
      let text = opt.node.text;
      let richText:MutableStyledString = new MutableStyledString(text);
      //设置样式
      this.setTextStyleWithOption(richText,opt);
      //设置点击事件
      let href:string|undefined = undefined;
      if (opt.parentNode?.tag && hrefTag[opt.parentNode.tag]){
         href = opt.parentNode?.attr?.href
         if (href) {
            this._setOnClick(richText,href);
         }
      }
      this.richText.appendStyledString(richText);
   }

   //image 目前只有群公告有图文混排
   appendImageStyledString(node:NodeInfo){
      if (!node.attr) {
         return
      }
      let url = node.attr.src;
      if (!url) {
         return
      }
      let w = node.attr['width']??200
      let h = node.attr['height']??200
      let imageSpan = ImageCustomSpan.creatStyledString(w as number,h as number,url);
      this.richText.appendStyledString(imageSpan);
   }


   //emoji表情
   appendEmojiStyledString(node:NodeInfo){
      let emojiInfo = StyledStringParser.emojiMap.get(node.text as string)
      if (!emojiInfo) {
         return
      }
      let emojiStyledString = EmojiIconSpan.creatStyledString(emojiInfo.tag,emojiInfo.path,this.config.emojiConfig)
      this.richText.appendStyledString(emojiStyledString);
   }


   //mark ------ 设置样式
   //设置所有富文本属性样式
   setTextStyleWithOption(styleString:MutableStyledString,opt: TextBuilderOptions){
      //字体、颜色
      this._setSpanStyle(styleString,opt);
      //装饰 如删除线、下划线
      this._setDecorationStyle(styleString,opt);
      //段落样式(对齐、缩进)
      this._setParagraphStyle(styleString,opt);
   }

   _setSpanStyle(styleString:MutableStyledString,opt: TextBuilderOptions){
      let styles = opt.parentNode?.artUIStyleObject;
      if (!styles){
         return
      }
      //字体
      let fontSize = Number(styles.fontSize)
      //粗细
      let fw = this.correctFontWeight(styles.fontWeight)
      let fontStyles:TextStyle = new TextStyle({
         fontSize:LengthMetrics.vp(fontSize),
         fontColor:styles.fontColor,//颜色
         fontStyle:styles.fontStyle,//字体样式（正常|斜体）  一直很疑惑 为啥斜体叫做意大利？？因为比萨斜塔？？
         fontWeight:fw,//字重
      })
      let spanStyles:SpanStyle = {
         start:0,
         length:styleString.length,
         styledKey:StyledStringKey.FONT,
         styledValue:fontStyles
      }
      //行高：字号+行间距
      let lineH = new LineHeightStyle(LengthMetrics.vp(fontSize+this.config.lineSpacing));
      let lhStyle:SpanStyle = {
         start:0,
         length:styleString.length,
         styledKey:StyledStringKey.LINE_HEIGHT,
         styledValue:lineH
      }
      styleString.setStyle(spanStyles)
      styleString.setStyle(lhStyle)
   }

   _setDecorationStyle(styleString:MutableStyledString,opt: TextBuilderOptions){
      let styles = opt.parentNode?.artUIStyleObject;
      if (!styles){
         return
      }
      let decoration = styles.decoration;
      if (!decoration) {
         return
      }
      let decorationStyle = new DecorationStyle({
         type:decoration.type,
         color:decoration.color
      });
      let span:SpanStyle = {
         start:0,
         length:styleString.length,
         styledKey:StyledStringKey.DECORATION,
         styledValue:decorationStyle
      }
      styleString.setStyle(span)
   }

   //段落样式 对齐、缩进
   _setParagraphStyle(styleString:MutableStyledString,opt: TextBuilderOptions){
      let styles = opt.parentNode?.artUIStyleObject;
      if (!styles) {
         return
      }
      //获取缩进
      let indentValue = 0;
      if (styles.textIndent!=undefined) {
         indentValue = this.getNumber(styles.textIndent);
      }
      let indent = LengthMetrics.vp(indentValue)
      //拿对齐方式
      let align = this.getAlign(styles);
      let pStyle = new ParagraphStyle({
         leadingMargin:indent,//明明是缩进，华为偏偏用这个。如果用textIndent那么会显示异常
         textAlign:align,
      });
      let span:SpanStyle = {
         start:0,
         length:styleString.length,
         styledKey:StyledStringKey.PARAGRAPH_STYLE,
         styledValue:pStyle
      }
      styleString.setStyle(span)
      if (align != TextAlign.Start) {
         this.shouldRenderFullWidth = true;
      }
   }

   _setLetterSpacingStyle(styleString:MutableStyledString,sp:number){
      // let spacing = new LetterSpacingStyle(LengthMetrics.vp(this.config.lineSpacing));
      let spacing = new LetterSpacingStyle(LengthMetrics.vp(sp));
      let span:SpanStyle = {
         start:0,
         length:styleString.length,
         styledKey:StyledStringKey.LETTER_SPACING,
         styledValue:spacing
      }
      styleString.setStyle(span)
   }

   //设置点击事件
   _setOnClick(styledString:MutableStyledString,href:string){
      let onClickAction = (()=>{
         if (this.tapAction) {
            this.tapAction(href,styledString);
         }
      })
      let gesture = new GestureStyle({onClick:onClickAction});
      let spanStyle:SpanStyle = {
         start:0,
         length:styledString.length,
         styledKey:StyledStringKey.GESTURE,
         styledValue:gesture
      }
      styledString.setStyle(spanStyle);
   }

   //mark ----- tools
   _setDefaultTextStyle(styleString:MutableStyledString){
      let fontSize = this.config.fontSize;
      let fontColor = this.config.fontColor;
      let fontStyles:TextStyle = new TextStyle({
         fontSize:LengthMetrics.vp(fontSize),
         fontColor:fontColor,
      })
      let spanStyles:SpanStyle = {
         start:0,
         length:styleString.length,
         styledKey:StyledStringKey.FONT,
         styledValue:fontStyles
      }
      styleString.setStyle(spanStyles)
   }

   correctFontWeight(fontSize:string|number|undefined):FontWeight{
      let fw = FontWeight.Normal;
      if (fontSize!=undefined) {
         let v = this.getNumber(fontSize)
         if (v == 0) {
            fw = FontWeight.Lighter
         }else if(v == 1){
            fw = FontWeight.Normal
         }else if(v == 2){
            fw = FontWeight.Regular
         }else if(v == 3){
            fw = FontWeight.Medium
         }else if(v == 4){
            fw = FontWeight.Bold
         }else if(v == 5){
            fw = FontWeight.Bolder
         }
      }
      return fw
   }

   getBlockIndex(node?: NodeInfo): number {
      const index = node?.nodes?.findIndex(n => n.tagType === 'block');
      return index as number;
   }

   getAlign(styles:ArtStyleObject):TextAlign{
      let align = TextAlign.Start;
      if (styles.textAlign!=undefined) {
         let styleAlign:string|number = styles.textAlign;
         align = this.getNumber(styleAlign);
         if (align == 0) {
            align = TextAlign.Center
         }else if(align == 2){
            align = TextAlign.End
         }else{
            align = TextAlign.Start
         }
      }
      return align
   }
   
   getNumber(v:string|number):number{
      if (typeof v === 'string') {
         return Number(v)
      }
      return v
   }
}


export function replaceEmojiTagToHtmlStyle(source:string):string{
   let regex = /\[#[^\]]*\]/g;   //+/g表示全文本搜索
   if (regex.test(source)) {
      return source.replace(regex,(match)=>{
         return '<emj name="' +match+ '">'+match+'</emj>';
      })
   }else{
      return source;
   }
}

///从原生富文本（styledString）拿纯文本
export function StyledStringGetPlainTextWithRange(styledString:MutableStyledString,rangeStart:number,rangeEnd:number):string{
   let subStyledString = styledString.subStyledString(rangeStart,rangeEnd);
   let styles = styledString.getStyles(0,subStyledString.length);
   let result = '';
   let lastBackedStyleSpan:SpanStyle|undefined = undefined;
   for (const element of styles) {
      if (element.styledValue instanceof BackedStringSpan) {
         //先加前面的
         let lastEnd = 0;
         if (lastBackedStyleSpan) {
            lastEnd = lastBackedStyleSpan.start+lastBackedStyleSpan.length;
         }
         let len = element.start - lastEnd;
         if (len>0) {
            let string = subStyledString.subStyledString(lastEnd,len).getString();
            result = result+string;
         }
         lastBackedStyleSpan = element;
         result+=element.styledValue.backedString
      }
   }
   let leftIndex = lastBackedStyleSpan?.start??0
   let left = subStyledString.subStyledString(leftIndex,subStyledString.length - leftIndex)
   result+=left.getString();
   return result;
}


