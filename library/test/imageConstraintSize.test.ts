import { describe, it } from 'node:test';
import assert from 'node:assert/strict';
import { resolveImageConstraintSize } from '../src/main/ets/common/utils/imageConstraintSize.ts';

describe('resolveImageConstraintSize', () => {
  it('does not apply the #107 maxHeight: 100% default that breaks objectFit Contain', () => {
    const resolved = resolveImageConstraintSize();

    assert.deepEqual(resolved, { maxWidth: '100%' });
    assert.equal(resolved.maxHeight, undefined);
    assert.equal(Object.prototype.hasOwnProperty.call(resolved, 'maxHeight'), false);
  });

  it('treats empty caller limits as unset and still omits maxHeight', () => {
    const resolved = resolveImageConstraintSize({});

    assert.deepEqual(resolved, { maxWidth: '100%' });
    assert.equal(resolved.maxHeight, undefined);
  });

  it('treats null caller limits as unset', () => {
    const resolved = resolveImageConstraintSize(null);

    assert.deepEqual(resolved, { maxWidth: '100%' });
    assert.equal(resolved.maxHeight, undefined);
  });

  it('applies only the size limits the caller actually set so Contain can coexist', () => {
    const resolved = resolveImageConstraintSize({ maxWidth: '80%' });

    assert.deepEqual(resolved, { maxWidth: '80%' });
    assert.equal(resolved.maxHeight, undefined);
    assert.equal(resolved.minWidth, undefined);
    assert.equal(resolved.minHeight, undefined);
  });

  it('preserves an explicit maxHeight when the caller opts into it', () => {
    const resolved = resolveImageConstraintSize({
      maxWidth: '100%',
      maxHeight: '200vp'
    });

    assert.deepEqual(resolved, {
      maxWidth: '100%',
      maxHeight: '200vp'
    });
  });

  it('does not invent maxWidth when the caller only set a height limit', () => {
    const resolved = resolveImageConstraintSize({ maxHeight: '400vp' });

    assert.deepEqual(resolved, { maxHeight: '400vp' });
    assert.equal(resolved.maxWidth, undefined);
  });
});
