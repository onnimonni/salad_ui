import { describe, it, expect } from "vitest";
import { createVirtualRect } from "../salad_ui/components/context_menu.js";

describe("createVirtualRect", () => {
  it("returns object with getBoundingClientRect method", () => {
    const vr = createVirtualRect(100, 200);
    expect(typeof vr.getBoundingClientRect).toBe("function");
  });

  it("returns rect at given coordinates", () => {
    const rect = createVirtualRect(150, 250).getBoundingClientRect();
    expect(rect.x).toBe(150);
    expect(rect.y).toBe(250);
    expect(rect.left).toBe(150);
    expect(rect.top).toBe(250);
    expect(rect.right).toBe(150);
    expect(rect.bottom).toBe(250);
  });

  it("has zero width and height", () => {
    const rect = createVirtualRect(0, 0).getBoundingClientRect();
    expect(rect.width).toBe(0);
    expect(rect.height).toBe(0);
  });

  it("handles negative coordinates", () => {
    const rect = createVirtualRect(-10, -20).getBoundingClientRect();
    expect(rect.x).toBe(-10);
    expect(rect.y).toBe(-20);
  });

  it("returns fresh rect each call", () => {
    const vr = createVirtualRect(10, 20);
    const r1 = vr.getBoundingClientRect();
    const r2 = vr.getBoundingClientRect();
    expect(r1).not.toBe(r2);
    expect(r1).toEqual(r2);
  });
});
