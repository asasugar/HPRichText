import display from '@ohos.display';
import type { ScreenInfo, Attr } from '../../types/HtmlParser';


export default class Node {
  node: 'element' | 'text' = 'element';
  tag: string;
  attr?: Attr;
  classStr?: string;
  $screen: ScreenInfo | null = null;
  tagType?: 'block' | 'inline' | 'closeSelf';
  artUIStyleObject?: Record<string, any>;

  constructor(tag: string) {
    this.tag = tag;
    this.getScreenInfo();
  }

  private getScreenInfo(): ScreenInfo | null {
    if (this.$screen) return this.$screen;
    const PREVIEW_DISPLAY: ScreenInfo = {
      width: 1228,
      height: 2700
    };
    try {
      const displayClass = display.getDefaultDisplaySync();
      // 方便previewer调试
      if (displayClass?.name?.includes('PC Preview')) {
        return PREVIEW_DISPLAY;
      } else {
        return {
          width: displayClass.width,
          height: displayClass.height,
        }
      }
    } catch (exception) {
      console.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
      return null;
    }
  }
}