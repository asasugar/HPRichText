declare module '@system.app' {
  // 这里导出 ArtUI 中的全局声明
  export interface ArtUI {
    // 假设 ArtUI 中有一个全局变量叫做 'Button'
    Button: string;
    // 以及其他你想要导出的类型定义
  }

  // 假设 ArtUI 中还有其他的全局声明，可以在这里继续添加
}