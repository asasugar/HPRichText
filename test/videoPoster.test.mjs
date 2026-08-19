/**
 * Node parser/builder test for HTML video poster → HarmonyOS Video.previewUri.
 * Bundles the HTML parser (no HarmonyOS device required).
 */
import { createRequire } from 'node:module';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { mkdtempSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { spawnSync } from 'node:child_process';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = join(__dirname, '..');
const parserEntry = join(repoRoot, 'library/src/main/ets/common/utils/html/html-parser.ts');
const videoBuilderPath = join(repoRoot, 'library/src/main/ets/components/hprichtext/builder/video.ets');

function bundle(entry) {
  const outDir = mkdtempSync(join(tmpdir(), 'hprichtext-videoposter-'));
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
    throw new Error(`${message}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
}

function assert(cond, message) {
  if (!cond) {
    throw new Error(message);
  }
}

const HTMLParser = bundle(parserEntry).default;

const posterUrl = 'https://example.com/poster.jpg';
const srcUrl = 'https://example.com/clip.mp4';
const parser = new HTMLParser({
  content: `<video height="500px" src="${srcUrl}" poster="${posterUrl}"></video>`
});
const videoNode = findFirstElement(parser.html2json().nodes, 'video');
assert(videoNode, 'parsed a video element');
assertEqual(videoNode.attr?.src, srcUrl, 'video src is preserved');
assertEqual(videoNode.attr?.poster, posterUrl, 'video poster attr is preserved for previewUri');

const noPosterParser = new HTMLParser({
  content: `<video src="${srcUrl}"></video>`
});
const noPosterNode = findFirstElement(noPosterParser.html2json().nodes, 'video');
assertEqual(noPosterNode?.attr?.poster, undefined, 'absent poster must not invent a poster attr');

const builderSource = readFileSync(videoBuilderPath, 'utf8');
assert(
  /previewUri\s*:\s*item\.attr\?\.poster/.test(builderSource),
  'videoBuilder must pass Video.previewUri from the poster attr'
);
assert(
  !builderSource.includes('.previewUri(') || /previewUri\s*:\s*item\.attr\?\.poster/.test(builderSource),
  'previewUri mapping must come from the HTML poster attr'
);

console.log('video poster → previewUri pipeline tests passed');
