// @ts-check
// saladui/components/toaster.js
import Component from "../core/component";
import SaladUI from "../index";

/** @type {Object<string, string>} */
const VARIANT_CLASSES = {
  default: "border bg-background text-foreground",
  destructive:
    "destructive group border-destructive bg-destructive text-destructive-foreground",
  success:
    "border-green-500 bg-green-50 text-green-900 dark:bg-green-950 dark:text-green-100",
  warning:
    "border-yellow-500 bg-yellow-50 text-yellow-900 dark:bg-yellow-950 dark:text-yellow-100",
  info: "border-blue-500 bg-blue-50 text-blue-900 dark:bg-blue-950 dark:text-blue-100",
};

/**
 * Get Tailwind classes for a toast variant.
 *
 * @param {string} variant - Toast variant name
 * @returns {string} CSS class string
 */
export function getVariantClasses(variant) {
  return VARIANT_CLASSES[variant] || VARIANT_CLASSES.default;
}

/**
 * Escape HTML special characters for safe insertion.
 *
 * @param {string} text - Raw text
 * @returns {string} HTML-escaped text
 */
export function escapeHtmlString(text) {
  const map = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#39;",
  };
  return text.replace(/[&<>"']/g, (ch) => map[ch]);
}

/**
 * Build the inner HTML for a toast element.
 *
 * @param {{ title?: string, description?: string }} toast - Toast data
 * @param {string} id - Toast element ID (for dismiss button data attr)
 * @returns {string} HTML string
 */
export function buildToastHTML(toast, id) {
  let html = '<div class="grid gap-1">';
  if (toast.title) {
    html += `<div class="text-sm font-semibold">${escapeHtmlString(toast.title)}</div>`;
  }
  if (toast.description) {
    html += `<div class="text-sm opacity-90">${escapeHtmlString(toast.description)}</div>`;
  }
  html += "</div>";

  html += `<button type="button" data-dismiss="${id}" class="absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none group-hover:opacity-100">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
    </button>`;

  return html;
}

/**
 * ToasterComponent - manages toast notifications
 * Handles auto-dismiss timers, pause-on-hover, and show/hide animations
 */
class ToasterComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    /** @type {Map<string, {el: HTMLElement, timer: {duration: number, remaining: number, startTime: number, timeoutId: number, paused: boolean}}>} */
    this.toasts = new Map();
    this.defaultDuration = parseInt(el.dataset.duration || "5000", 10);
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        idle: {
          transitions: {},
        },
      },
      events: {},
      ariaConfig: {
        root: {
          all: {
            role: "region",
            label: "Notifications",
            live: "polite",
          },
        },
      },
    };
  }

  setupComponentEvents() {
    // Listen for toast events from LiveView
    this.handleToastEvent = (event) => {
      const { toast } = event.detail;
      if (toast) {
        this.addToast(toast);
      }
    };

    this.el.addEventListener("salad_ui:toast", this.handleToastEvent);

    // Also listen via phx hook for push_event
    if (this.hook) {
      this.hook.handleEvent("add_toast", (toast) => {
        this.addToast(toast);
      });
    }

    // Pause on hover
    this.el.addEventListener("mouseenter", () => this.pauseAll());
    this.el.addEventListener("mouseleave", () => this.resumeAll());
  }

  /** @param {{ id?: string, duration?: number, variant?: string, title?: string, description?: string }} toast */
  addToast(toast) {
    const id =
      toast.id ||
      `toast-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;
    const duration = toast.duration || this.defaultDuration;

    // Create toast element
    const toastEl = document.createElement("div");
    toastEl.id = id;
    toastEl.setAttribute("data-part", "toast");
    toastEl.setAttribute("data-state", "open");
    toastEl.setAttribute("data-variant", toast.variant || "default");
    toastEl.setAttribute("role", "status");
    toastEl.setAttribute("aria-live", "off");

    const variantClasses = getVariantClasses(toast.variant || "default");

    toastEl.className = `group pointer-events-auto relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-80 data-[state=closed]:slide-out-to-right-full data-[state=open]:slide-in-from-top-full data-[state=open]:sm:slide-in-from-bottom-full ${variantClasses}`;

    toastEl.innerHTML = buildToastHTML(toast, id);

    // Add dismiss handler
    const dismissBtn = toastEl.querySelector(`[data-dismiss="${id}"]`);
    if (dismissBtn) {
      dismissBtn.addEventListener("click", () => this.dismissToast(id));
    }

    this.el.appendChild(toastEl);

    // Set up auto-dismiss timer
    const timer = {
      duration,
      remaining: duration,
      startTime: Date.now(),
      timeoutId: setTimeout(() => this.dismissToast(id), duration),
      paused: false,
    };

    this.toasts.set(id, { el: toastEl, timer });
  }

  /** @param {string} id */
  dismissToast(id) {
    const toast = this.toasts.get(id);
    if (!toast) return;

    clearTimeout(toast.timer.timeoutId);
    toast.el.setAttribute("data-state", "closed");

    // Remove after animation
    setTimeout(() => {
      toast.el.remove();
      this.toasts.delete(id);
    }, 300);
  }

  pauseAll() {
    this.toasts.forEach((toast) => {
      if (!toast.timer.paused) {
        clearTimeout(toast.timer.timeoutId);
        toast.timer.remaining -= Date.now() - toast.timer.startTime;
        toast.timer.paused = true;
      }
    });
  }

  resumeAll() {
    this.toasts.forEach((toast, id) => {
      if (toast.timer.paused) {
        toast.timer.startTime = Date.now();
        toast.timer.timeoutId = setTimeout(
          () => this.dismissToast(id),
          toast.timer.remaining,
        );
        toast.timer.paused = false;
      }
    });
  }

  beforeDestroy() {
    this.toasts.forEach((toast) => {
      clearTimeout(toast.timer.timeoutId);
    });
    this.toasts.clear();
    this.el.removeEventListener("salad_ui:toast", this.handleToastEvent);
  }
}

SaladUI.register("toaster", ToasterComponent);

export default ToasterComponent;
