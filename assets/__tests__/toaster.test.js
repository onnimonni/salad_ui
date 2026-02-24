import { describe, it, expect } from "vitest";
import {
  getVariantClasses,
  escapeHtmlString,
  buildToastHTML,
} from "../salad_ui/components/toaster.js";

describe("getVariantClasses", () => {
  it("returns default classes for 'default' variant", () => {
    const classes = getVariantClasses("default");
    expect(classes).toContain("bg-background");
    expect(classes).toContain("text-foreground");
  });

  it("returns destructive classes", () => {
    const classes = getVariantClasses("destructive");
    expect(classes).toContain("bg-destructive");
    expect(classes).toContain("text-destructive-foreground");
  });

  it("returns success classes", () => {
    const classes = getVariantClasses("success");
    expect(classes).toContain("border-green-500");
  });

  it("returns warning classes", () => {
    const classes = getVariantClasses("warning");
    expect(classes).toContain("border-yellow-500");
  });

  it("returns info classes", () => {
    const classes = getVariantClasses("info");
    expect(classes).toContain("border-blue-500");
  });

  it("falls back to default for unknown variant", () => {
    expect(getVariantClasses("unknown")).toBe(getVariantClasses("default"));
  });
});

describe("escapeHtmlString", () => {
  it("escapes ampersand", () => {
    expect(escapeHtmlString("a&b")).toBe("a&amp;b");
  });

  it("escapes angle brackets", () => {
    expect(escapeHtmlString("<div>")).toBe("&lt;div&gt;");
  });

  it("escapes quotes", () => {
    expect(escapeHtmlString('"hello"')).toBe("&quot;hello&quot;");
    expect(escapeHtmlString("it's")).toBe("it&#39;s");
  });

  it("handles no special chars", () => {
    expect(escapeHtmlString("hello world")).toBe("hello world");
  });

  it("handles empty string", () => {
    expect(escapeHtmlString("")).toBe("");
  });

  it("escapes all special chars together", () => {
    expect(escapeHtmlString('<a href="x">&')).toBe(
      "&lt;a href=&quot;x&quot;&gt;&amp;",
    );
  });
});

describe("buildToastHTML", () => {
  it("includes title when provided", () => {
    const html = buildToastHTML({ title: "Test Title" }, "t1");
    expect(html).toContain("Test Title");
    expect(html).toContain("font-semibold");
  });

  it("includes description when provided", () => {
    const html = buildToastHTML({ description: "Some description" }, "t1");
    expect(html).toContain("Some description");
    expect(html).toContain("opacity-90");
  });

  it("includes both title and description", () => {
    const html = buildToastHTML(
      { title: "T", description: "D" },
      "t1",
    );
    expect(html).toContain("T");
    expect(html).toContain("D");
  });

  it("includes dismiss button with correct id", () => {
    const html = buildToastHTML({ title: "X" }, "toast-42");
    expect(html).toContain('data-dismiss="toast-42"');
  });

  it("escapes HTML in title", () => {
    const html = buildToastHTML({ title: "<script>alert('xss')</script>" }, "t1");
    expect(html).not.toContain("<script>");
    expect(html).toContain("&lt;script&gt;");
  });

  it("handles no title or description", () => {
    const html = buildToastHTML({}, "t1");
    expect(html).toContain("grid gap-1");
    expect(html).toContain('data-dismiss="t1"');
  });
});
