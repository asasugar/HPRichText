import BasicDataSource from './BasicDataSource';

export default class RichTextDataSource<T = string> extends BasicDataSource<T> {
  private dataArray: T[];

  constructor(content: T[]) {
    super();
    this.dataArray = content;
  }

  public totalCount (): number {
    return this.dataArray.length;
  }

  public getData (index: number): T {
    return this.dataArray[index];
  }
}