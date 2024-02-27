export interface Attribute {
  name: string;
  value: string;
  escaped: string;
}

export interface TextNode {
  node: 'text';
  text?: string;
}

export interface NodeInfo {
  node: 'element' | 'text';
  tag?: string;
  $screen?: {
    width: number;
    height: number;
  };
  tagType?: 'block' | 'inline' | 'closeSelf';
  styleObj?: Record<string, any>;
  attr?: Record<string, any>;
  classStr?: string;
  text?: string;
  nodes?: NodeInfo[];
}
