// ets中调用js不支持的方法


// 数组合并
export function assign(target: Object, ...args: Object[]) {
  return Object.assign(target, ...args);
}