// @ts-check
// saladui/components/menubar.js
import Component from "../core/component";
import SaladUI from "../index";

/**
 * Calculate the next menu index given navigation direction, wrapping at boundaries.
 *
 * @param {number} current - Current active menu index
 * @param {"next"|"prev"} direction - Navigation direction
 * @param {number} total - Total number of menus
 * @returns {number} New menu index, or current if out of bounds
 */
export function getNextMenuIndex(current, direction, total) {
  if (total <= 0) return current;

  if (direction === "next") {
    return current < total - 1 ? current + 1 : current;
  }
  // direction === "prev"
  return current > 0 ? current - 1 : current;
}

/**
 * MenubarComponent - coordinates multiple dropdown menus in a horizontal bar
 * Handles arrow key navigation between menus and hover-to-switch when one is open
 */
class MenubarComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    this.menus = [];
    this.activeMenuIndex = -1;

    this.config.preventDefaultKeys = ["ArrowLeft", "ArrowRight", "Escape"];
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        idle: {
          transitions: {
            "menu-opened": "active",
          },
        },
        active: {
          enter: "onActiveEnter",
          transitions: {
            "menu-closed": "idle",
            "switch-menu": "active",
          },
        },
      },
      events: {
        active: {
          keyMap: {
            ArrowLeft: "navigatePrev",
            ArrowRight: "navigateNext",
            Escape: "closeActive",
          },
        },
      },
      ariaConfig: {
        root: {
          all: {
            role: "menubar",
          },
        },
      },
    };
  }

  setupComponentEvents() {
    // Find all dropdown-menu children and track them
    this.menuRoots = Array.from(
      this.el.querySelectorAll("[data-component='dropdown-menu']"),
    );

    // Listen for state changes on child menus
    this.menuObserver = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (mutation.attributeName === "data-state") {
          const target = /** @type {HTMLElement} */ (mutation.target);
          const state = target.getAttribute("data-state");
          const index = this.menuRoots.indexOf(target);
          if (index === -1) continue;

          if (state === "open") {
            this.activeMenuIndex = index;
            this.transition("menu-opened");
          } else if (state === "closed" && index === this.activeMenuIndex) {
            this.activeMenuIndex = -1;
            this.transition("menu-closed");
          }
        }
      }
    });

    this.menuRoots.forEach((menu) => {
      this.menuObserver.observe(menu, { attributes: true });
    });

    // Hover-to-switch: when a menu is open and user hovers another trigger
    this.menuRoots.forEach((menu, index) => {
      const trigger = menu.querySelector("[data-part='trigger']");
      if (trigger) {
        trigger.addEventListener("mouseenter", () => {
          if (this.state === "active" && index !== this.activeMenuIndex) {
            this.switchToMenu(index);
          }
        });
      }
    });
  }

  onActiveEnter() {
    // Focus is managed by the dropdown menu itself
  }

  navigatePrev() {
    const newIndex = getNextMenuIndex(
      this.activeMenuIndex,
      "prev",
      this.menuRoots.length,
    );
    if (newIndex !== this.activeMenuIndex) {
      this.switchToMenu(newIndex);
    }
  }

  navigateNext() {
    const newIndex = getNextMenuIndex(
      this.activeMenuIndex,
      "next",
      this.menuRoots.length,
    );
    if (newIndex !== this.activeMenuIndex) {
      this.switchToMenu(newIndex);
    }
  }

  closeActive() {
    if (this.activeMenuIndex >= 0) {
      const menu = this.menuRoots[this.activeMenuIndex];
      if (menu) {
        menu.dispatchEvent(
          new CustomEvent("salad_ui:command", {
            detail: { command: "close" },
          }),
        );
      }
    }
  }

  /** @param {number} newIndex */
  switchToMenu(newIndex) {
    // Close current
    if (this.activeMenuIndex >= 0) {
      const currentMenu = this.menuRoots[this.activeMenuIndex];
      if (currentMenu) {
        currentMenu.dispatchEvent(
          new CustomEvent("salad_ui:command", {
            detail: { command: "close" },
          }),
        );
      }
    }

    // Open new
    const newMenu = this.menuRoots[newIndex];
    if (newMenu) {
      // Small delay to let close finish
      requestAnimationFrame(() => {
        newMenu.dispatchEvent(
          new CustomEvent("salad_ui:command", {
            detail: { command: "open" },
          }),
        );
      });
    }

    this.activeMenuIndex = newIndex;
  }

  beforeDestroy() {
    if (this.menuObserver) {
      this.menuObserver.disconnect();
      this.menuObserver = null;
    }
  }
}

SaladUI.register("menubar", MenubarComponent);

export default MenubarComponent;
