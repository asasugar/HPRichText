import type { NodeInfo } from '../../types/htmlParser';

/**
 * Nested inline tags inherit ancestor <a> href / onClick so the link still fires
 * when the click lands on an inner span (or other inline wrapper).
 */
export function inheritClickableAttrs(node: NodeInfo, parent?: NodeInfo): void {
  if (node.tagType !== 'inline' || !parent?.attr) {
    return;
  }
  if (!node.attr) {
    node.attr = {};
  }
  if (parent.attr.href !== undefined && node.attr.href === undefined) {
    node.attr.href = parent.attr.href;
  }
  if (parent.attr.onClick !== undefined && node.attr.onClick === undefined) {
    node.attr.onClick = parent.attr.onClick;
  }
}

export function isClickableNode(node?: NodeInfo): boolean {
  if (!node) {
    return false;
  }
  return node.tag === 'a' || !!node.attr?.onClick || !!node.attr?.href;
}

/**
 * Mirrors spanBuilder onClick gating: a node is clickable when it is an <a>,
 * has onClick, or inherited href; isInlinePushNode still honors clickIndex.
 */
export function shouldFireNodeClick(parentNode?: NodeInfo, index: number = 0): boolean {
  if (!isClickableNode(parentNode)) {
    return false;
  }
  const clickIndex: number = parentNode?.attr?.clickIndex ?? 0;
  if (parentNode?.isInlinePushNode && index !== clickIndex) {
    return false;
  }
  return true;
}

export function resolveLinkPress(parentNode?: NodeInfo, text?: string) {
  return {
    text,
    link: parentNode?.attr?.href,
    eventFnName: parentNode?.attr?.onClick
  };
}
