import { describe, it, expect } from "vitest";
import {
  filterInputByPattern,
  calculateSlotState,
} from "../salad_ui/components/input_otp.js";

describe("filterInputByPattern", () => {
  const digitPattern = /\d/;

  it("filters non-matching characters", () => {
    expect(filterInputByPattern("a1b2c3", digitPattern, 6)).toBe("123");
  });

  it("truncates to maxLength", () => {
    expect(filterInputByPattern("123456789", digitPattern, 4)).toBe("1234");
  });

  it("returns empty for no matches", () => {
    expect(filterInputByPattern("abcdef", digitPattern, 6)).toBe("");
  });

  it("handles empty input", () => {
    expect(filterInputByPattern("", digitPattern, 6)).toBe("");
  });

  it("works with alpha pattern", () => {
    const alphaPattern = /[a-z]/;
    expect(filterInputByPattern("a1b2c3", alphaPattern, 6)).toBe("abc");
  });

  it("respects maxLength of 0", () => {
    expect(filterInputByPattern("123", digitPattern, 0)).toBe("");
  });
});

describe("calculateSlotState", () => {
  it("returns filled state for character at index", () => {
    const state = calculateSlotState("123", 0, false);
    expect(state.char).toBe("1");
    expect(state.isFilled).toBe(true);
    expect(state.isActive).toBe(false);
  });

  it("returns empty state for index beyond value", () => {
    const state = calculateSlotState("12", 3, false);
    expect(state.char).toBe("");
    expect(state.isFilled).toBe(false);
    expect(state.isActive).toBe(false);
  });

  it("marks active slot when focused at cursor position", () => {
    // value "12" has length 2, so slot 2 is where caret goes
    const state = calculateSlotState("12", 2, true);
    expect(state.isActive).toBe(true);
    expect(state.isFilled).toBe(false);
  });

  it("does not mark active when not focused", () => {
    const state = calculateSlotState("12", 2, false);
    expect(state.isActive).toBe(false);
  });

  it("filled slot is not active even when focused", () => {
    const state = calculateSlotState("123", 1, true);
    expect(state.char).toBe("2");
    expect(state.isFilled).toBe(true);
    expect(state.isActive).toBe(false);
  });

  it("handles empty value", () => {
    const state = calculateSlotState("", 0, true);
    expect(state.char).toBe("");
    expect(state.isFilled).toBe(false);
    expect(state.isActive).toBe(true);
  });
});
