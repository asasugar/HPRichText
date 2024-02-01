const blockDom = [
  'div',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'hr',
  'header',
  'footer',
  'nav',
  'main',
  'article',
  'section',
  'address',
  'blockquote',
  'pre',
  'ul',
  'ol',
  'li',
  'dl',
  'dt',
  'dd',
  'table',
  'tr',
  'th',
  'td',
  'form',
  'fieldset',
  'legend'
]

const inlineDom = [
  'a', // 超链接
  'span', // 常用于文本内容的容器，保持在同一行内
  'img', // 图像
  'input', // 输入框（不同类型的input可能有不同的默认display属性）
  'button', // 按钮
  'select', // 选择列表
  'textarea', // 文本区域（尽管它通常会形成新的行，但在CSS默认行为下是inline元素）
  'label', // 标签
  'strong', // 加重文本（强调）
  'em', // 斜体文本（强调）
  'code', // 计算机代码文本
  'samp', // 示例计算机输出文本
  'kbd', // 用户输入（如键盘输入）
  'var', // 变量
  'cite', // 引用
  'abbr', // 缩写
  'sub', // 下标
  'sup', // 上标
  'time', // 时间元素
  'mark', // 高亮文本
  'q', // 短引用
  'ruby', // 注音/拼音文本容器
  'rt', // ruby注释的解释文本
  'rp', // 在不支持ruby元素的浏览器中显示注释文本
  'bdi', // 方向隔离元素，用于双向文本排版
  'bdo', // 方向覆盖元素，用于强制文本方向
]
type BlockDom = typeof blockDom;
type BlockKey = keyof BlockDom;

export function getDomType(dom: BlockDom[BlockKey]) {

}

getDomType('a') {
}