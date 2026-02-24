// @ts-check
// saladui/components/input_otp.js
import Component from "../core/component";
import SaladUI from "../index";

/**
 * Filter an input string to only characters matching the pattern, capped at maxLength.
 *
 * @param {string} input - Raw input string
 * @param {RegExp} pattern - Pattern each character must match
 * @param {number} maxLength - Maximum output length
 * @returns {string} Filtered string
 */
export function filterInputByPattern(input, pattern, maxLength) {
  return input
    .split("")
    .filter((ch) => pattern.test(ch))
    .join("")
    .slice(0, maxLength);
}

/**
 * Calculate the display state of an OTP slot.
 *
 * @param {string} value - Current OTP value
 * @param {number} index - Slot index
 * @param {boolean} isFocused - Whether the OTP input is focused
 * @returns {import("../core/types.js").SlotState} Slot display state
 */
export function calculateSlotState(value, index, isFocused) {
  const char = value[index] || "";
  return {
    char,
    isActive: isFocused && index === value.length,
    isFilled: char !== "",
  };
}

/**
 * InputOTPComponent - one-time password input with auto-advance
 * Hidden input captures keystrokes, visual slots display individual chars
 */
class InputOTPComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    this.hiddenInput = /** @type {HTMLInputElement|null} */ (
      this.el.querySelector("[data-part='hidden-input']")
    );
    /** @type {HTMLElement[]} */
    this.slots = /** @type {HTMLElement[]} */ (
      Array.from(this.el.querySelectorAll("[data-part='slot']"))
    );
    this.maxLength = parseInt(this.el.dataset.maxLength || "6", 10);
    this.pattern = new RegExp(this.el.dataset.pattern || "\\d");

    this.value = this.hiddenInput?.value || "";

    this.config.preventDefaultKeys = [];
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        idle: {
          transitions: {
            focus: "focused",
          },
        },
        focused: {
          enter: "onFocusedEnter",
          exit: "onFocusedExit",
          transitions: {
            blur: "idle",
            complete: "idle",
          },
        },
      },
      events: {},
      ariaConfig: {
        root: {
          all: {
            role: "group",
            label: "One-time password input",
          },
        },
      },
    };
  }

  setupComponentEvents() {
    if (!this.hiddenInput) return;

    this.onInputFocus = () => this.transition("focus");
    this.onInputBlur = () => this.transition("blur");
    this.onInputInput = (e) => this.handleInput(e);
    this.onInputKeyDown = (e) => this.handleKeyDown(e);
    this.onInputPaste = (e) => this.handlePaste(e);
    this.onSlotClick = () => {
      this.hiddenInput.focus();
    };

    this.hiddenInput.addEventListener("focus", this.onInputFocus);
    this.hiddenInput.addEventListener("blur", this.onInputBlur);
    this.hiddenInput.addEventListener("input", this.onInputInput);
    this.hiddenInput.addEventListener("keydown", this.onInputKeyDown);
    this.hiddenInput.addEventListener("paste", this.onInputPaste);

    // Click on any slot focuses the hidden input
    this.slots.forEach((slot) => {
      slot.addEventListener("click", this.onSlotClick);
    });

    this.updateSlots();
  }

  onFocusedEnter() {
    this.el.setAttribute("data-focused", "true");
    this.updateSlots();
  }

  onFocusedExit() {
    this.el.removeAttribute("data-focused");
    this.updateSlots();
  }

  /** @param {Event} e */
  handleInput(e) {
    const filtered = filterInputByPattern(
      /** @type {HTMLInputElement} */ (e.target).value,
      this.pattern,
      this.maxLength,
    );

    this.value = filtered;
    this.hiddenInput.value = filtered;
    this.updateSlots();
    this.pushEvent("on-change", { value: this.value });

    if (this.value.length >= this.maxLength) {
      this.pushEvent("on-complete", { value: this.value });
      this.hiddenInput.blur();
    }
  }

  /** @param {KeyboardEvent} e */
  handleKeyDown(e) {
    if (e.key === "Backspace") {
      e.preventDefault();
      this.value = this.value.slice(0, -1);
      this.hiddenInput.value = this.value;
      this.updateSlots();
      this.pushEvent("on-change", { value: this.value });
    }
  }

  /** @param {ClipboardEvent} e */
  handlePaste(e) {
    e.preventDefault();
    const pasted = e.clipboardData?.getData("text") || "";
    const filtered = filterInputByPattern(pasted, this.pattern, this.maxLength);

    this.value = filtered;
    this.hiddenInput.value = filtered;
    this.updateSlots();
    this.pushEvent("on-change", { value: this.value });

    if (this.value.length >= this.maxLength) {
      this.pushEvent("on-complete", { value: this.value });
      this.hiddenInput.blur();
    }
  }

  updateSlots() {
    const isFocused = this.state === "focused";

    this.slots.forEach((slot, i) => {
      const slotState = calculateSlotState(this.value, i, isFocused);
      const charEl = slot.querySelector("[data-part='slot-char']");
      const caretEl = /** @type {HTMLElement|null} */ (
        slot.querySelector("[data-part='slot-caret']")
      );

      if (charEl) {
        charEl.textContent = slotState.char;
      }

      slot.setAttribute("data-active", slotState.isActive ? "true" : "false");

      if (caretEl) {
        caretEl.hidden = !slotState.isActive;
      }

      slot.setAttribute("data-filled", slotState.isFilled ? "true" : "false");
    });
  }

  beforeDestroy() {
    if (this.hiddenInput) {
      this.hiddenInput.removeEventListener("focus", this.onInputFocus);
      this.hiddenInput.removeEventListener("blur", this.onInputBlur);
      this.hiddenInput.removeEventListener("input", this.onInputInput);
      this.hiddenInput.removeEventListener("keydown", this.onInputKeyDown);
      this.hiddenInput.removeEventListener("paste", this.onInputPaste);
    }
    this.slots.forEach((slot) => {
      slot.removeEventListener("click", this.onSlotClick);
    });
  }
}

SaladUI.register("input-otp", InputOTPComponent);

export default InputOTPComponent;
