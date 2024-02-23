export default class Stack extends Array {
  // last方法返回数组的最后一项值
  last() {
    return this[this.length - 1];
  }
}

