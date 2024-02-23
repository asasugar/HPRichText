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

export interface Handler {
  start?(tagName: string, attrs: {
    name: string;
    value: string;
    escaped: string
  }[], unary: boolean): void;

  end?(tagName: string): void;

  chars?(text: string): void;
}