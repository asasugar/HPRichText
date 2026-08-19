import { describe, it, expect } from '@ohos/hypium'
import { HTMLParser } from '@ohasasugar/hp-richtext'
import type { NodeInfo } from '@ohasasugar/hp-richtext'

function findFirstTag(nodes: NodeInfo[] | undefined, tag: string): NodeInfo | undefined {
  if (!nodes) {
    return undefined;
  }
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    if (node.tag === tag) {
      return node;
    }
    const nested = findFirstTag(node.nodes, tag);
    if (nested) {
      return nested;
    }
  }
  return undefined;
}

export default function nestedAnchorClickTest() {
  describe('NestedAnchorClickTest', function () {
    it('nested_a_span_inherits_href', 0, function () {
      const parser = new HTMLParser({
        content: '<a href="http://www.baidu.com"><span>a标签</span></a>'
      });
      const result = parser.html2json();
      const span = findFirstTag(result.nodes, 'span');
      expect(span?.attr?.href).assertEqual('http://www.baidu.com');
    })

    it('nested_a_span_b_inherits_href', 0, function () {
      const parser = new HTMLParser({
        content: '<a href="https://example.com"><span><b>deep</b></span></a>'
      });
      const result = parser.html2json();
      const bold = findFirstTag(result.nodes, 'b');
      expect(bold?.attr?.href).assertEqual('https://example.com');
    })
  })
}
