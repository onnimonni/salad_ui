// @ts-check
// saladui/components/navigation_menu.js
import Component from "../core/component";
import SaladUI from "../index";

/**
 * Calculate indicator position relative to parent.
 *
 * @param {{ left: number, width: number }} triggerRect - Trigger element's bounding rect
 * @param {{ left: number }} parentRect - Parent element's bounding rect
 * @returns {{ width: number, translateX: number }} Position values in px
 */
export function calculateIndicatorPosition(triggerRect, parentRect) {
  return {
    width: triggerRect.width,
    translateX: triggerRect.left - parentRect.left,
  };
}

/**
 * NavigationMenuComponent - hover-activated navigation with content panels
 * Manages hover delays, indicator animation, and viewport content switching
 */
class NavigationMenuComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    this.viewport = /** @type {HTMLElement|null} */ (
      this.el.querySelector("[data-part='viewport']")
    );
    this.indicator = /** @type {HTMLElement|null} */ (
      this.el.querySelector("[data-part='indicator']")
    );
    /** @type {HTMLElement[]} */
    this.items = /** @type {HTMLElement[]} */ (
      Array.from(this.el.querySelectorAll("[data-part='nav-item']"))
    );
    this.activeItem = null;
    this.hoverTimeout = null;
    this.closeTimeout = null;
    this.hoverDelay = 200;
    this.closeDelay = 300;
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        idle: {
          transitions: {
            open: "open",
          },
        },
        open: {
          enter: "onOpenEnter",
          exit: "onOpenExit",
          transitions: {
            close: "idle",
            switch: "open",
          },
        },
      },
      events: {},
      ariaConfig: {
        root: {
          all: {
            role: "navigation",
          },
        },
      },
    };
  }

  setupComponentEvents() {
    this.items.forEach((item) => {
      const trigger = item.querySelector("[data-part='nav-trigger']");
      const content = item.querySelector("[data-part='nav-content']");

      if (!trigger || !content) return;

      trigger.addEventListener("mouseenter", () => {
        clearTimeout(this.closeTimeout);
        this.hoverTimeout = setTimeout(
          () => {
            this.openItem(item);
          },
          this.state === "open" ? 0 : this.hoverDelay,
        );
      });

      trigger.addEventListener("mouseleave", () => {
        clearTimeout(this.hoverTimeout);
        this.closeTimeout = setTimeout(() => {
          this.closeAll();
        }, this.closeDelay);
      });

      // Click also toggles
      trigger.addEventListener("click", (e) => {
        e.preventDefault();
        if (this.activeItem === item) {
          this.closeAll();
        } else {
          this.openItem(item);
        }
      });
    });

    // Keep open when hovering viewport
    if (this.viewport) {
      this.viewport.addEventListener("mouseenter", () => {
        clearTimeout(this.closeTimeout);
      });

      this.viewport.addEventListener("mouseleave", () => {
        this.closeTimeout = setTimeout(() => {
          this.closeAll();
        }, this.closeDelay);
      });
    }
  }

  /** @param {HTMLElement} item */
  openItem(item) {
    // Hide all content panels
    this.items.forEach((i) => {
      const content = /** @type {HTMLElement|null} */ (
        i.querySelector("[data-part='nav-content']")
      );
      const trigger = /** @type {HTMLElement|null} */ (
        i.querySelector("[data-part='nav-trigger']")
      );
      if (content) content.hidden = true;
      if (trigger) trigger.setAttribute("data-state", "closed");
    });

    // Show the active content
    const content = /** @type {HTMLElement|null} */ (
      item.querySelector("[data-part='nav-content']")
    );
    const trigger = /** @type {HTMLElement|null} */ (
      item.querySelector("[data-part='nav-trigger']")
    );
    if (content) content.hidden = false;
    if (trigger) trigger.setAttribute("data-state", "open");

    this.activeItem = item;

    // Show viewport
    if (this.viewport) {
      this.viewport.hidden = false;
      this.viewport.setAttribute("data-state", "open");
    }

    // Update indicator position
    this.updateIndicator(trigger);

    if (this.state !== "open") {
      this.transition("open");
    }
  }

  closeAll() {
    this.items.forEach((i) => {
      const content = /** @type {HTMLElement|null} */ (
        i.querySelector("[data-part='nav-content']")
      );
      const trigger = /** @type {HTMLElement|null} */ (
        i.querySelector("[data-part='nav-trigger']")
      );
      if (content) content.hidden = true;
      if (trigger) trigger.setAttribute("data-state", "closed");
    });

    if (this.viewport) {
      this.viewport.hidden = true;
      this.viewport.setAttribute("data-state", "closed");
    }

    if (this.indicator) {
      this.indicator.hidden = true;
    }

    this.activeItem = null;

    if (this.state === "open") {
      this.transition("close");
    }
  }

  /** @param {HTMLElement} trigger */
  updateIndicator(trigger) {
    if (!this.indicator || !trigger) return;

    const triggerRect = trigger.getBoundingClientRect();
    const parentRect = this.el.getBoundingClientRect();
    const pos = calculateIndicatorPosition(triggerRect, parentRect);

    this.indicator.hidden = false;
    this.indicator.style.width = `${pos.width}px`;
    this.indicator.style.transform = `translateX(${pos.translateX}px)`;
  }

  onOpenEnter() {
    this.pushEvent("opened");
  }

  onOpenExit() {
    this.pushEvent("closed");
  }

  beforeDestroy() {
    clearTimeout(this.hoverTimeout);
    clearTimeout(this.closeTimeout);
  }
}

SaladUI.register("navigation-menu", NavigationMenuComponent);

export default NavigationMenuComponent;
