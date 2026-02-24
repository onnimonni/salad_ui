// @ts-check
// saladui/components/context_menu.js
import Component from "../core/component";
import PositionedElement from "../core/positioned-element";
import SaladUI from "../index";
import Menu from "./menu";

/**
 * Create a virtual DOMRect-like object at the given coordinates.
 * Used to position floating elements at cursor location.
 *
 * @param {number} x - Horizontal coordinate
 * @param {number} y - Vertical coordinate
 * @returns {{ getBoundingClientRect: () => { x: number, y: number, width: number, height: number, top: number, right: number, bottom: number, left: number } }} Virtual element with getBoundingClientRect
 */
export function createVirtualRect(x, y) {
  return {
    getBoundingClientRect: () => ({
      x,
      y,
      width: 0,
      height: 0,
      top: y,
      right: x,
      bottom: y,
      left: x,
    }),
  };
}

/**
 * ContextMenuComponent - right-click triggered menu
 * Extends dropdown menu pattern but triggers on contextmenu event
 * and positions at cursor coordinates
 */
class ContextMenuComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    this.trigger = this.getPart("trigger");
    this.positioner = this.getPart("positioner");
    this.content = this.positioner.querySelector("[data-part='content']");

    this.menu = new Menu(this.content, {
      hookContext,
      onItemSelect: this.onItemSelect.bind(this),
    });

    this.config.preventDefaultKeys = ["Escape", "ArrowDown", " ", "Enter"];

    // Store cursor position for positioning
    this.cursorX = 0;
    this.cursorY = 0;
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        closed: {
          enter: "onClosedEnter",
          transitions: {
            open: "open",
          },
        },
        open: {
          enter: "onOpenEnter",
          transitions: {
            close: "closed",
          },
        },
      },
      events: {
        open: {
          keyMap: {
            Escape: "close",
          },
        },
      },
      hiddenConfig: {
        closed: {
          positioner: true,
        },
        open: {
          positioner: false,
        },
      },
      ariaConfig: {
        trigger: {
          all: {
            haspopup: "menu",
          },
          open: {
            expanded: "true",
          },
          closed: {
            expanded: "false",
          },
        },
        content: {
          all: {
            role: "menu",
          },
        },
      },
    };
  }

  setupComponentEvents() {
    // Right-click on trigger
    this.onContextMenu = (e) => {
      e.preventDefault();
      this.cursorX = e.clientX;
      this.cursorY = e.clientY;
      this.transition("open");
    };

    this.trigger.addEventListener("contextmenu", this.onContextMenu);
  }

  initializePositionedElement() {
    if (this.positionedElement) {
      this.positionedElement.destroy();
      this.positionedElement = null;
    }

    const virtualTrigger = createVirtualRect(this.cursorX, this.cursorY);

    this.positionedElement = new PositionedElement(
      this.positioner,
      /** @type {any} */ (virtualTrigger),
      {
        placement: "bottom",
        alignment: "start",
        sideOffset: 2,
        alignOffset: 0,
        flip: true,
        trapFocus: false,
        onOutsideClick: () => this.transition("close"),
      },
    );
  }

  onOpenEnter() {
    this.previousFocusEl = /** @type {HTMLElement|null} */ (
      document.activeElement
    );
    this.initializePositionedElement();
    this.positionedElement?.activate();
    this.menu.activate();
    this.pushEvent("opened");
  }

  onClosedEnter() {
    this.positionedElement?.deactivate();
    this.pushEvent("closed");
    this.previousFocusEl?.focus();
    this.previousFocusEl = null;
  }

  onItemSelect(_item) {
    this.transition("close");
  }

  beforeDestroy() {
    if (this.trigger) {
      this.trigger.removeEventListener("contextmenu", this.onContextMenu);
    }
    if (this.positionedElement) {
      this.positionedElement.destroy();
      this.positionedElement = null;
    }
    if (this.menu) {
      this.menu.destroy();
      this.menu = null;
    }
  }
}

SaladUI.register("context-menu", ContextMenuComponent);

export default ContextMenuComponent;
