import type { Attr } from '../../types/HtmlParser';


export default class Node {
  node: 'element' | 'text' = 'element';
  tag: string;
  attr?: Attr;
  tagType?: 'block' | 'inline' | 'closeSelf';
  artUIStyleObject?: Record<string, any>;

  constructor(tag: string) {
    this.tag = tag;
  }
}