import { describe, it, expect } from "vitest";
import {
  getNextIndex,
  detectSwipeDirection,
} from "../salad_ui/components/carousel.js";

describe("getNextIndex", () => {
  it("advances forward within bounds", () => {
    expect(getNextIndex(0, 5, "next", false)).toBe(1);
    expect(getNextIndex(3, 5, "next", false)).toBe(4);
  });

  it("stays at last index when not looping", () => {
    expect(getNextIndex(4, 5, "next", false)).toBe(4);
  });

  it("wraps to 0 when looping forward past end", () => {
    expect(getNextIndex(4, 5, "next", true)).toBe(0);
  });

  it("goes backward within bounds", () => {
    expect(getNextIndex(3, 5, "prev", false)).toBe(2);
    expect(getNextIndex(1, 5, "prev", false)).toBe(0);
  });

  it("stays at 0 when not looping backward", () => {
    expect(getNextIndex(0, 5, "prev", false)).toBe(0);
  });

  it("wraps to last when looping backward past start", () => {
    expect(getNextIndex(0, 5, "prev", true)).toBe(4);
  });

  it("returns current for zero total", () => {
    expect(getNextIndex(0, 0, "next", true)).toBe(0);
    expect(getNextIndex(0, 0, "prev", true)).toBe(0);
  });

  it("handles single item", () => {
    expect(getNextIndex(0, 1, "next", false)).toBe(0);
    expect(getNextIndex(0, 1, "prev", false)).toBe(0);
    expect(getNextIndex(0, 1, "next", true)).toBe(0);
    expect(getNextIndex(0, 1, "prev", true)).toBe(0);
  });
});

describe("detectSwipeDirection", () => {
  it("returns 'next' for negative delta exceeding threshold", () => {
    expect(detectSwipeDirection(-60, 50)).toBe("next");
  });

  it("returns 'prev' for positive delta exceeding threshold", () => {
    expect(detectSwipeDirection(60, 50)).toBe("prev");
  });

  it("returns null for delta at threshold", () => {
    expect(detectSwipeDirection(50, 50)).toBeNull();
    expect(detectSwipeDirection(-50, 50)).toBeNull();
  });

  it("returns null for delta below threshold", () => {
    expect(detectSwipeDirection(30, 50)).toBeNull();
    expect(detectSwipeDirection(-10, 50)).toBeNull();
  });

  it("handles zero delta", () => {
    expect(detectSwipeDirection(0, 50)).toBeNull();
  });
});
