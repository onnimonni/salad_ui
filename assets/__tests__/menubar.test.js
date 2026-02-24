import { describe, it, expect } from "vitest";
import { getNextMenuIndex } from "../salad_ui/components/menubar.js";

describe("getNextMenuIndex", () => {
  it("moves to next index", () => {
    expect(getNextMenuIndex(0, "next", 3)).toBe(1);
    expect(getNextMenuIndex(1, "next", 3)).toBe(2);
  });

  it("stays at last when moving next at end", () => {
    expect(getNextMenuIndex(2, "next", 3)).toBe(2);
  });

  it("moves to previous index", () => {
    expect(getNextMenuIndex(2, "prev", 3)).toBe(1);
    expect(getNextMenuIndex(1, "prev", 3)).toBe(0);
  });

  it("stays at 0 when moving prev at start", () => {
    expect(getNextMenuIndex(0, "prev", 3)).toBe(0);
  });

  it("returns current for zero total", () => {
    expect(getNextMenuIndex(0, "next", 0)).toBe(0);
    expect(getNextMenuIndex(0, "prev", 0)).toBe(0);
  });

  it("handles single menu", () => {
    expect(getNextMenuIndex(0, "next", 1)).toBe(0);
    expect(getNextMenuIndex(0, "prev", 1)).toBe(0);
  });
});
