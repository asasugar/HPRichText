import type { Attr, ArtStyleObject } from '../../types/htmlParser';


export default class Node {
  node: 'element' | 'text' = 'element';
  tag: string;
  attr?: Attr = {};
  tagType?: 'block' | 'inline' | 'closeSelf';
  artUIStyleObject?: ArtStyleObject;

  constructor(tag: string) {
    this.tag = tag;
  }
}