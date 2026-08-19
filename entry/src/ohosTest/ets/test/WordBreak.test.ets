import { describe, it, expect } from '@ohos/hypium'
import { HTMLParser, parseToArtUI, WordBreak } from '@ohasasugar/hp-richtext'
import type { NodeInfo } from '@ohasasugar/hp-richtext'

function findFirstElement(nodes?: NodeInfo[], tag?: string): NodeInfo | undefined {
  if (!nodes?.length) {
    return undefined;
  }
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    if (node.node === 'element' && (!tag || node.tag === tag)) {
      return node;
    }
    const child = findFirstElement(node.nodes, tag);
    if (child) {
      return child;
    }
  }
  return undefined;
}

export default function wordBreakTest() {
  describe('WordBreakStylePipeline', () => {
    it('parseToArtUI_mapsCssWordBreakToArkUIEnum', 0, () => {
      expect(parseToArtUI({ 'word-break': 'normal' }).wordBreak).assertEqual(WordBreak.NORMAL);
      expect(parseToArtUI({ 'word-break': 'break-all' }).wordBreak).assertEqual(WordBreak.BREAK_ALL);
      expect(parseToArtUI({ 'word-break': 'break-word' }).wordBreak).assertEqual(WordBreak.BREAK_WORD);
    })

    it('htmlParser_appliesWordBreakOnTextHostAndInherits', 0, () => {
      const parser = new HTMLParser({
        content: '<p style="word-break: break-all"><span>ABC123</span></p>'
      });
      const result = parser.html2json();
      const pNode = findFirstElement(result.nodes, 'p');
      const spanNode = findFirstElement(result.nodes, 'span');
      expect(pNode?.artUIStyleObject?.wordBreak).assertEqual(WordBreak.BREAK_ALL);
      expect(spanNode?.artUIStyleObject?.wordBreak).assertEqual(WordBreak.BREAK_ALL);
    })

    it('richTextOption_wordBreak_reachesArtUIStyleObject', 0, () => {
      const parser = new HTMLParser({
        content: '<p>ABC123</p>',
        wordBreak: WordBreak.NORMAL
      });
      const result = parser.html2json();
      const pNode = findFirstElement(result.nodes, 'p');
      expect(pNode?.artUIStyleObject?.wordBreak).assertEqual(WordBreak.NORMAL);
    })

    it('cssWordBreak_overridesRichTextOptionDefault', 0, () => {
      const parser = new HTMLParser({
        content: '<p style="word-break: break-word">ABC123</p>',
        wordBreak: WordBreak.NORMAL
      });
      const result = parser.html2json();
      const pNode = findFirstElement(result.nodes, 'p');
      expect(pNode?.artUIStyleObject?.wordBreak).assertEqual(WordBreak.BREAK_WORD);
    })
  })
}
