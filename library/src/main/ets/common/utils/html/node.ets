import display from '@ohos.display';

export default class Node {
  node: 'element' | 'text';
  tag: string;
  attr: any;
  classStr: string;
  styleObj: any;
  $screen: any;
  tagType: 'block' | 'inline' | 'closeSelf';

  constructor(tag) {
    this.node = 'element';
    this.tag = tag;
    this.$screen = this.getScreenInfo();
  }

  private getScreenInfo() {
    if (this.$screen) return this.$screen;
    let displayClass = null;
    let screen = null;
    const PREVIEW_DISPLAY = {
      width: 1228,
      height: 2700
    };
    try {
      displayClass = display.getDefaultDisplaySync();
      // 方便previewer调试
      if (displayClass?.name?.includes('PC Preview')) {
        screen = PREVIEW_DISPLAY;
      } else {
        screen.width = displayClass.width;
        screen.height = displayClass.height;
      }
    } catch (exception) {
      console.error('Failed to obtain the default display object. Code: ' + JSON.stringify(exception));
    }
    return screen;
  }
}