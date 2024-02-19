export interface TagInfo {
  tagName: string;
  attrs: {
    name: string;
    value: string;
    escaped: string
  }[];
  unary: boolean;
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