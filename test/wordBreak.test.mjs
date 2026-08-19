/**
 * Node parser test for the Text.wordBreak style pipeline.
 * Bundles the library CSS/HTML parser (no HarmonyOS device required).
 */
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { mkdtempSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { spawnSync } from 'node:child_process';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(__dirname, '..');
const cssEntry = join(repoRoot, 'library/src/main/ets/common/utils/css/index.ts');
const parserEntry = join(repoRoot, 'library/src/main/ets/common/utils/html/html-parser.ts');

function bundle(entry) {
  const outDir = mkdtempSync(join(tmpdir(), 'hprichtext-wordbreak-'));
  const outfile = join(outDir, 'bundle.cjs');
  const result = spawnSync('npx', [
    '--yes',
    'esbuild',
    entry,
    '--bundle',
    '--platform=node',
    '--format=cjs',
    `--outfile=${outfile}`
  ], { encoding: 'utf8' });
  if (result.status !== 0) {
    throw new Error(`esbuild failed for ${entry}:\n${result.stderr || result.stdout}`);
  }
  return createRequire(import.meta.url)(outfile);
}

function findFirstElement(nodes, tag) {
  if (!nodes?.length) {
    return undefined;
  }
  for (const node of nodes) {
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

function assertEqual(actual, expected, message) {
  if (actual !== expected) {
    throw new Error(`${message}: expected ${expected}, got ${actual}`);
  }
}

const WordBreak = {
  NORMAL: 0,
  BREAK_ALL: 1,
  BREAK_WORD: 2
};

const { parseToArtUI } = bundle(cssEntry);
const HTMLParser = bundle(parserEntry).default;

assertEqual(parseToArtUI({ 'word-break': 'normal' }).wordBreak, WordBreak.NORMAL,
  'CSS word-break:normal');
assertEqual(parseToArtUI({ 'word-break': 'break-all' }).wordBreak, WordBreak.BREAK_ALL,
  'CSS word-break:break-all');
assertEqual(parseToArtUI({ 'word-break': 'break-word' }).wordBreak, WordBreak.BREAK_WORD,
  'CSS word-break:break-word');
assertEqual(parseToArtUI({ 'text-align': 'center' }).textAlign, 1,
  'existing textAlign mapping still works');
assertEqual(parseToArtUI({ color: 'red' }).wordBreak, undefined,
  'unrelated CSS must not invent wordBreak');

const cssParser = new HTMLParser({
  content: '<p style="word-break: break-all"><span>ABC123</span></p>'
});
const cssResult = cssParser.html2json();
const pNode = findFirstElement(cssResult.nodes, 'p');
const spanNode = findFirstElement(cssResult.nodes, 'span');
assertEqual(pNode?.artUIStyleObject?.wordBreak, WordBreak.BREAK_ALL,
  'p.artUIStyleObject.wordBreak from CSS');
assertEqual(spanNode?.artUIStyleObject?.wordBreak, WordBreak.BREAK_ALL,
  'span inherits parent wordBreak');

const optionParser = new HTMLParser({
  content: '<p>ABC123</p>',
  wordBreak: WordBreak.NORMAL
});
const optionResult = optionParser.html2json();
const optionP = findFirstElement(optionResult.nodes, 'p');
assertEqual(optionP?.artUIStyleObject?.wordBreak, WordBreak.NORMAL,
  'RichTextOption.wordBreak reaches artUIStyleObject');

const overrideParser = new HTMLParser({
  content: '<p style="word-break: break-word">ABC123</p>',
  wordBreak: WordBreak.NORMAL
});
const overrideP = findFirstElement(overrideParser.html2json().nodes, 'p');
assertEqual(overrideP?.artUIStyleObject?.wordBreak, WordBreak.BREAK_WORD,
  'inline CSS word-break overrides RichTextOption.wordBreak');

const fancyTextFiles = [
  'library/src/main/ets/components/hprichtext/HPRichText.ets',
  'library/src/main/ets/components/hprichtext/HPRichTextV2.ets',
  'library/src/main/ets/components/hprichtext/ObservedHPRichText.ets'
];
for (const relative of fancyTextFiles) {
  const source = readFileSync(join(repoRoot, relative), 'utf8');
  if (!source.includes('.wordBreak($$.wordBreak)')) {
    throw new Error(`${relative} does not apply Text.wordBreak from artUIStyleObject`);
  }
}

console.log('wordBreak style pipeline tests passed');
