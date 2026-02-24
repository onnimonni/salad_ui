import { describe, it, expect } from "vitest";
import { calculateIndicatorPosition } from "../salad_ui/components/navigation_menu.js";

describe("calculateIndicatorPosition", () => {
  it("calculates width from trigger rect", () => {
    const pos = calculateIndicatorPosition(
      { left: 100, width: 80 },
      { left: 50 },
    );
    expect(pos.width).toBe(80);
  });

  it("calculates translateX as difference from parent left", () => {
    const pos = calculateIndicatorPosition(
      { left: 100, width: 80 },
      { left: 50 },
    );
    expect(pos.translateX).toBe(50);
  });

  it("handles trigger at parent origin", () => {
    const pos = calculateIndicatorPosition(
      { left: 200, width: 100 },
      { left: 200 },
    );
    expect(pos.translateX).toBe(0);
    expect(pos.width).toBe(100);
  });

  it("handles negative offset", () => {
    const pos = calculateIndicatorPosition(
      { left: 30, width: 60 },
      { left: 50 },
    );
    expect(pos.translateX).toBe(-20);
  });

  it("handles zero width trigger", () => {
    const pos = calculateIndicatorPosition(
      { left: 100, width: 0 },
      { left: 50 },
    );
    expect(pos.width).toBe(0);
    expect(pos.translateX).toBe(50);
  });
});
