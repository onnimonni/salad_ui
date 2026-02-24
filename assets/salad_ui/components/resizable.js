// @ts-check
// saladui/components/resizable.js
import Component from "../core/component";
import SaladUI from "../index";

/**
 * Clamp a size value within min/max bounds.
 *
 * @param {number} size - Size in percent
 * @param {number} min - Minimum allowed size
 * @param {number} max - Maximum allowed size
 * @returns {number} Clamped size
 */
export function clampSize(size, min, max) {
  return Math.max(min, Math.min(max, size));
}

/**
 * Check whether a panel should collapse based on its raw (unclamped) size.
 *
 * @param {number} rawSize - The unclamped panel size
 * @param {number} minSize - Panel's minimum size threshold
 * @param {boolean} collapsible - Whether the panel supports collapsing
 * @returns {boolean} True if the panel should collapse to 0
 */
export function shouldCollapse(rawSize, minSize, collapsible) {
  return collapsible && rawSize < minSize / 2;
}

/**
 * Calculate new panel sizes after a drag delta, respecting constraints.
 * Checks collapse on raw values BEFORE clamping to avoid dead-code collapse logic.
 *
 * @param {number} sizeA - Current size of panel A in percent
 * @param {number} sizeB - Current size of panel B in percent
 * @param {number} delta - Drag delta in percent (positive = A grows)
 * @param {{ minA: number, maxA: number, collapsibleA: boolean, minB: number, maxB: number, collapsibleB: boolean }} constraints
 * @returns {import("../core/types.js").ResizeResult}
 */
export function calculateNewSizes(sizeA, sizeB, delta, constraints) {
  const { minA, maxA, collapsibleA, minB, maxB, collapsibleB } = constraints;

  let newSizeA = sizeA + delta;
  let newSizeB = sizeB - delta;

  // Check collapse on raw values BEFORE clamping
  if (shouldCollapse(newSizeA, minA, collapsibleA)) {
    newSizeA = 0;
  } else {
    newSizeA = clampSize(newSizeA, minA, maxA);
  }

  if (shouldCollapse(newSizeB, minB, collapsibleB)) {
    newSizeB = 0;
  } else {
    newSizeB = clampSize(newSizeB, minB, maxB);
  }

  return { sizeA: newSizeA, sizeB: newSizeB };
}

/**
 * ResizableComponent - drag-resizable panel layout
 * Tracks mousemove/touchmove on handles to resize panels
 */
class ResizableComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    this.direction = this.options.direction || "horizontal";
    /** @type {HTMLElement[]} */
    this.panels = /** @type {HTMLElement[]} */ (
      Array.from(this.el.querySelectorAll("[data-part='panel']"))
    );
    /** @type {HTMLElement[]} */
    this.handles = /** @type {HTMLElement[]} */ (
      Array.from(this.el.querySelectorAll("[data-part='handle']"))
    );

    this.activeHandle = null;
    this.panelSizes = [];

    this.initializePanelSizes();

    this.config.preventDefaultKeys = [];
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        idle: {
          transitions: {
            drag: "dragging",
          },
        },
        dragging: {
          enter: "onDragEnter",
          exit: "onDragExit",
          transitions: {
            end: "idle",
          },
        },
      },
      events: {},
      ariaConfig: {},
    };
  }

  initializePanelSizes() {
    this.panelSizes = this.panels.map((panel) => {
      const defaultSize = parseFloat(panel.dataset.defaultSize || "0");
      return defaultSize;
    });

    // If no defaults, distribute equally
    const total = this.panelSizes.reduce((a, b) => a + b, 0);
    if (total === 0) {
      const equalSize = 100 / this.panels.length;
      this.panelSizes = this.panels.map(() => equalSize);
    }

    this.applyPanelSizes();
  }

  setupComponentEvents() {
    // Bind handlers
    this.onPointerMove = this.onPointerMove.bind(this);
    this.onPointerUp = this.onPointerUp.bind(this);

    this.handles.forEach((handle, index) => {
      handle.addEventListener("mousedown", (e) => {
        e.preventDefault();
        this.startDrag(index, /** @type {MouseEvent} */ (e));
      });
      handle.addEventListener(
        "touchstart",
        (e) => {
          this.startDrag(index, /** @type {TouchEvent} */ (e));
        },
        { passive: false },
      );

      // Keyboard support
      handle.addEventListener("keydown", (e) => {
        const ke = /** @type {KeyboardEvent} */ (e);
        const step = 5;
        const isHorizontal = this.direction === "horizontal";

        if (
          (isHorizontal && ke.key === "ArrowLeft") ||
          (!isHorizontal && ke.key === "ArrowUp")
        ) {
          ke.preventDefault();
          this.resizeByStep(index, -step);
        } else if (
          (isHorizontal && ke.key === "ArrowRight") ||
          (!isHorizontal && ke.key === "ArrowDown")
        ) {
          ke.preventDefault();
          this.resizeByStep(index, step);
        }
      });
    });
  }

  /**
   * @param {number} handleIndex
   * @param {MouseEvent|TouchEvent} event
   */
  startDrag(handleIndex, event) {
    this.activeHandle = handleIndex;
    this.startPointer = this.getPointerPosition(event);
    this.startSizes = [...this.panelSizes];
    this.transition("drag");
  }

  onDragEnter() {
    document.addEventListener("mousemove", this.onPointerMove);
    document.addEventListener("touchmove", this.onPointerMove, {
      passive: false,
    });
    document.addEventListener("mouseup", this.onPointerUp);
    document.addEventListener("touchend", this.onPointerUp);

    if (this.activeHandle !== null) {
      this.handles[this.activeHandle]?.setAttribute("data-dragging", "true");
    }
  }

  onDragExit() {
    document.removeEventListener("mousemove", this.onPointerMove);
    document.removeEventListener("touchmove", this.onPointerMove);
    document.removeEventListener("mouseup", this.onPointerUp);
    document.removeEventListener("touchend", this.onPointerUp);

    for (const h of this.handles) {
      h.removeAttribute("data-dragging");
    }
  }

  /** @param {MouseEvent|TouchEvent} event */
  onPointerMove(event) {
    if (this.activeHandle === null) return;
    event.preventDefault();

    const currentPointer = this.getPointerPosition(event);
    const containerRect = this.el.getBoundingClientRect();
    const containerSize =
      this.direction === "horizontal"
        ? containerRect.width
        : containerRect.height;

    const delta = ((currentPointer - this.startPointer) / containerSize) * 100;

    const panelA = this.activeHandle;
    const panelB = this.activeHandle + 1;

    if (panelA >= this.panels.length || panelB >= this.panels.length) return;

    const result = calculateNewSizes(
      this.startSizes[panelA],
      this.startSizes[panelB],
      delta,
      {
        minA: parseFloat(this.panels[panelA].dataset.minSize || "0"),
        maxA: parseFloat(this.panels[panelA].dataset.maxSize || "100"),
        collapsibleA: this.panels[panelA].dataset.collapsible === "true",
        minB: parseFloat(this.panels[panelB].dataset.minSize || "0"),
        maxB: parseFloat(this.panels[panelB].dataset.maxSize || "100"),
        collapsibleB: this.panels[panelB].dataset.collapsible === "true",
      },
    );

    this.panelSizes[panelA] = result.sizeA;
    this.panelSizes[panelB] = result.sizeB;

    this.applyPanelSizes();
  }

  onPointerUp() {
    this.activeHandle = null;
    this.transition("end");
    this.pushEvent("layout-changed", {
      sizes: this.panelSizes.map((s) => Math.round(s * 10) / 10),
    });
  }

  /**
   * @param {number} handleIndex
   * @param {number} step
   */
  resizeByStep(handleIndex, step) {
    const panelA = handleIndex;
    const panelB = handleIndex + 1;
    if (panelB >= this.panels.length) return;

    this.panelSizes[panelA] = Math.max(0, this.panelSizes[panelA] + step);
    this.panelSizes[panelB] = Math.max(0, this.panelSizes[panelB] - step);

    this.applyPanelSizes();
    this.pushEvent("layout-changed", {
      sizes: this.panelSizes.map((s) => Math.round(s * 10) / 10),
    });
  }

  applyPanelSizes() {
    this.panels.forEach((panel, i) => {
      const size = this.panelSizes[i];
      if (this.direction === "horizontal") {
        panel.style.width = `${size}%`;
        panel.style.height = "100%";
      } else {
        panel.style.height = `${size}%`;
        panel.style.width = "100%";
      }
      panel.setAttribute("data-size", size);
    });
  }

  /**
   * @param {MouseEvent|TouchEvent} event
   * @returns {number}
   */
  getPointerPosition(event) {
    const clientPos = "touches" in event ? event.touches[0] : event;
    return this.direction === "horizontal"
      ? clientPos.clientX
      : clientPos.clientY;
  }

  beforeDestroy() {
    document.removeEventListener("mousemove", this.onPointerMove);
    document.removeEventListener("touchmove", this.onPointerMove);
    document.removeEventListener("mouseup", this.onPointerUp);
    document.removeEventListener("touchend", this.onPointerUp);
  }
}

SaladUI.register("resizable", ResizableComponent);

export default ResizableComponent;
