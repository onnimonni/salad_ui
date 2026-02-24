import { describe, it, expect } from "vitest";
import {
  clampSize,
  shouldCollapse,
  calculateNewSizes,
} from "../salad_ui/components/resizable.js";

describe("clampSize", () => {
  it("returns value within bounds", () => {
    expect(clampSize(50, 10, 90)).toBe(50);
  });

  it("clamps to minimum", () => {
    expect(clampSize(5, 10, 90)).toBe(10);
  });

  it("clamps to maximum", () => {
    expect(clampSize(95, 10, 90)).toBe(90);
  });

  it("handles equal min and max", () => {
    expect(clampSize(50, 30, 30)).toBe(30);
  });

  it("handles zero min", () => {
    expect(clampSize(-5, 0, 100)).toBe(0);
  });
});

describe("shouldCollapse", () => {
  it("collapses when raw size is below half of min and collapsible", () => {
    // minSize=20, half=10, rawSize=8 → should collapse
    expect(shouldCollapse(8, 20, true)).toBe(true);
  });

  it("does not collapse when above half of min", () => {
    expect(shouldCollapse(12, 20, true)).toBe(false);
  });

  it("does not collapse when not collapsible", () => {
    expect(shouldCollapse(5, 20, false)).toBe(false);
  });

  it("does not collapse at exactly half of min", () => {
    expect(shouldCollapse(10, 20, true)).toBe(false);
  });

  it("collapses at just below half", () => {
    expect(shouldCollapse(9.99, 20, true)).toBe(true);
  });

  it("handles zero minSize", () => {
    // minSize=0, half=0, rawSize must be < 0 to collapse
    expect(shouldCollapse(-1, 0, true)).toBe(true);
    expect(shouldCollapse(0, 0, true)).toBe(false);
  });
});

describe("calculateNewSizes", () => {
  const defaultConstraints = {
    minA: 10,
    maxA: 90,
    collapsibleA: false,
    minB: 10,
    maxB: 90,
    collapsibleB: false,
  };

  it("adjusts sizes by delta", () => {
    const result = calculateNewSizes(50, 50, 10, defaultConstraints);
    expect(result.sizeA).toBe(60);
    expect(result.sizeB).toBe(40);
  });

  it("clamps A to minimum", () => {
    const result = calculateNewSizes(50, 50, -50, defaultConstraints);
    expect(result.sizeA).toBe(10); // clamped to minA
    expect(result.sizeB).toBe(90); // clamped to maxB
  });

  it("clamps B to minimum", () => {
    const result = calculateNewSizes(50, 50, 50, defaultConstraints);
    expect(result.sizeA).toBe(90); // clamped to maxA
    expect(result.sizeB).toBe(10); // clamped to minB
  });

  it("collapses panel A when collapsible and below threshold", () => {
    const constraints = { ...defaultConstraints, collapsibleA: true };
    // sizeA=50 + delta=-48 = 2, which is < minA/2 (5) → collapse to 0
    const result = calculateNewSizes(50, 50, -48, constraints);
    expect(result.sizeA).toBe(0);
  });

  it("does not collapse non-collapsible panel", () => {
    const result = calculateNewSizes(50, 50, -48, defaultConstraints);
    expect(result.sizeA).toBe(10); // clamped, not collapsed
  });

  it("collapses panel B when collapsible", () => {
    const constraints = { ...defaultConstraints, collapsibleB: true };
    const result = calculateNewSizes(50, 50, 48, constraints);
    expect(result.sizeB).toBe(0);
  });

  it("handles zero delta", () => {
    const result = calculateNewSizes(50, 50, 0, defaultConstraints);
    expect(result.sizeA).toBe(50);
    expect(result.sizeB).toBe(50);
  });

  it("bug fix: collapse is checked before clamp (not dead code)", () => {
    // Previously: clamp first made rawSize=minA, then collapse check was unreachable
    // Now: collapse check on raw value, then clamp only if not collapsing
    const constraints = {
      ...defaultConstraints,
      collapsibleA: true,
      minA: 20,
    };
    // sizeA=25 + delta=-20 = 5, which is < minA/2 (10) → should collapse
    const result = calculateNewSizes(25, 75, -20, constraints);
    expect(result.sizeA).toBe(0);
  });
});
