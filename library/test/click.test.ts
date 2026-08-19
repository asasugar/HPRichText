/**
 * Focused unit tests for nested <a><span> click/href inheritance (#111).
 * Run: node --experimental-strip-types library/test/click.test.ts
 */
import type { NodeInfo } from '../src/main/ets/common/types/htmlParser';
import {
  inheritClickableAttrs,
  isClickableNode,
  resolveLinkPress,
  shouldFireNodeClick
} from '../src/main/ets/common/utils/html/click.ts';

function collectLinkPressFromTree(
  nodes?: NodeInfo[],
  parentNode?: NodeInfo
): Array<{ text?: string; link?: string; eventFnName?: string }> {
  const result: Array<{ text?: string; link?: string; eventFnName?: string }> = [];
  if (!nodes?.length) {
    return result;
  }
  for (let i = 0; i < nodes.length; i++) {
    const item = nodes[i];
    if (item.node === 'element' && item.nodes?.length) {
      const nested = collectLinkPressFromTree(item.nodes, item);
      for (let j = 0; j < nested.length; j++) {
        result.push(nested[j]);
      }
    } else if (item.node === 'text' && shouldFireNodeClick(parentNode, i)) {
      result.push(resolveLinkPress(parentNode, item.text));
    }
  }
  return result;
}

let failed = 0;
let passed = 0;

function assert(cond: boolean, message: string): void {
  if (cond) {
    passed += 1;
    console.log(`  ok  ${message}`);
  } else {
    failed += 1;
    console.error(`  FAIL ${message}`);
  }
}

function assertEqual(actual: unknown, expected: unknown, message: string): void {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (!ok) {
    console.error(`    expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
  assert(ok, message);
}

function issue111Tree(): NodeInfo {
  const anchor: NodeInfo = {
    node: 'element',
    tag: 'a',
    tagType: 'inline',
    attr: { href: 'http://www.baidu.com', clickIndex: 0 },
    nodes: []
  };
  const span: NodeInfo = {
    node: 'element',
    tag: 'span',
    tagType: 'inline',
    attr: {},
    nodes: [{ node: 'text', text: 'a标签' }]
  };
  inheritClickableAttrs(span, anchor);
  if (isClickableNode(span) && span.attr) {
    span.attr.clickIndex = 0;
  }
  anchor.nodes = [span];
  return anchor;
}

console.log('#111 nested a>span inherits href');
const nested = issue111Tree();
assertEqual(nested.nodes?.[0]?.attr?.href, 'http://www.baidu.com', 'span inherits parent <a> href');
assert(isClickableNode(nested.nodes?.[0]), 'nested span is clickable after inherit');
assert(shouldFireNodeClick(nested.nodes?.[0], 0), 'click on inner span text should fire');

const presses = collectLinkPressFromTree([nested]);
assertEqual(presses.length, 1, 'exactly one link press from a>span text');
assertEqual(presses[0]?.link, 'http://www.baidu.com', 'fired link is the inherited href');
assertEqual(presses[0]?.text, 'a标签', 'fired text is the span content');

console.log('plain <a> text still fires');
const plainA: NodeInfo = {
  node: 'element',
  tag: 'a',
  tagType: 'inline',
  attr: { href: 'http://www.baidu.com', clickIndex: 0 },
  nodes: [{ node: 'text', text: 'a标签' }]
};
assert(shouldFireNodeClick(plainA, 0), 'direct <a> text is clickable');
assertEqual(collectLinkPressFromTree([plainA])[0]?.link, 'http://www.baidu.com', 'direct <a> keeps href');

console.log('non-link span does not fire');
const lonelySpan: NodeInfo = {
  node: 'element',
  tag: 'span',
  tagType: 'inline',
  attr: {},
  nodes: [{ node: 'text', text: 'plain' }]
};
assert(!shouldFireNodeClick(lonelySpan, 0), 'span without href/onClick is not clickable');
assertEqual(collectLinkPressFromTree([lonelySpan]).length, 0, 'no press from non-link span');

console.log('deeper inline nest a>span>b inherits through the chain');
const a: NodeInfo = {
  node: 'element',
  tag: 'a',
  tagType: 'inline',
  attr: { href: 'https://example.com', clickIndex: 0 },
  nodes: []
};
const span: NodeInfo = { node: 'element', tag: 'span', tagType: 'inline', attr: {}, nodes: [] };
const bold: NodeInfo = {
  node: 'element',
  tag: 'b',
  tagType: 'inline',
  attr: {},
  nodes: [{ node: 'text', text: 'deep' }]
};
inheritClickableAttrs(span, a);
inheritClickableAttrs(bold, span);
a.nodes = [span];
span.nodes = [bold];
assertEqual(bold.attr?.href, 'https://example.com', 'b inherits href via span');
assertEqual(collectLinkPressFromTree([a])[0]?.link, 'https://example.com', 'deep nest still fires inherited href');

console.log('child href is not overwritten by parent');
const innerA: NodeInfo = {
  node: 'element',
  tag: 'a',
  tagType: 'inline',
  attr: { href: 'https://child.example' },
  nodes: [{ node: 'text', text: 'child' }]
};
inheritClickableAttrs(innerA, a);
assertEqual(innerA.attr?.href, 'https://child.example', 'nested <a> keeps its own href');

console.log('onClick also propagates to nested inline');
const clickSpan: NodeInfo = {
  node: 'element',
  tag: 'span',
  tagType: 'inline',
  attr: { onClick: 'handleSpanClick' },
  nodes: []
};
const innerB: NodeInfo = {
  node: 'element',
  tag: 'b',
  tagType: 'inline',
  attr: {},
  nodes: [{ node: 'text', text: 'tap' }]
};
inheritClickableAttrs(innerB, clickSpan);
assertEqual(innerB.attr?.onClick, 'handleSpanClick', 'nested inline inherits onClick');
assertEqual(resolveLinkPress(innerB, 'tap').eventFnName, 'handleSpanClick', 'resolveLinkPress exposes inherited onClick');

console.log('isInlinePushNode still honors clickIndex');
const pushed: NodeInfo = {
  node: 'element',
  tag: 'span',
  tagType: 'inline',
  isInlinePushNode: true,
  attr: { href: 'http://www.baidu.com', clickIndex: 1 },
  nodes: [
    { node: 'text', text: 'before' },
    { node: 'text', text: 'link' }
  ]
};
assert(!shouldFireNodeClick(pushed, 0), 'index 0 does not fire when clickIndex is 1');
assert(shouldFireNodeClick(pushed, 1), 'clickIndex text does fire');

console.log('block children do not inherit');
const block: NodeInfo = { node: 'element', tag: 'div', tagType: 'block', attr: {} };
inheritClickableAttrs(block, a);
assertEqual(block.attr?.href, undefined, 'block child does not inherit href');

if (failed) {
  console.error(`\n${failed} failed, ${passed} passed`);
  process.exit(1);
}
console.log(`\n${passed} passed`);
