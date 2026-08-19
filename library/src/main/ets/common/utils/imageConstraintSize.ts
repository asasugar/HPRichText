import type { ImageConstraintSize } from '../types/htmlParser';

export type { ImageConstraintSize };

function hasDefinedLimit(limits?: ImageConstraintSize | null): boolean {
  if (!limits) {
    return false;
  }
  return limits.minWidth !== undefined
    || limits.maxWidth !== undefined
    || limits.minHeight !== undefined
    || limits.maxHeight !== undefined;
}

function pickDefinedLimits(limits: ImageConstraintSize): ImageConstraintSize {
  const resolved: ImageConstraintSize = {};
  if (limits.minWidth !== undefined) {
    resolved.minWidth = limits.minWidth;
  }
  if (limits.maxWidth !== undefined) {
    resolved.maxWidth = limits.maxWidth;
  }
  if (limits.minHeight !== undefined) {
    resolved.minHeight = limits.minHeight;
  }
  if (limits.maxHeight !== undefined) {
    resolved.maxHeight = limits.maxHeight;
  }
  return resolved;
}

/**
 * Resolve Image.constraintSize so it can coexist with objectFit (Contain).
 *
 * Issue #107 asked for maxWidth: 100% so wide images do not overflow.
 * Commit b4f1d31 also hardcoded maxHeight: 100%, which boxes the image to the
 * parent height and makes objectFit=Contain appear broken (#113).
 *
 * - No caller limits: apply maxWidth 100% only (never default maxHeight).
 * - Caller-provided limits: apply only the keys they actually set.
 */
export function resolveImageConstraintSize(
  callerLimits?: ImageConstraintSize | null
): ImageConstraintSize {
  if (hasDefinedLimit(callerLimits)) {
    return pickDefinedLimits(callerLimits as ImageConstraintSize);
  }
  return { maxWidth: '100%' };
}
