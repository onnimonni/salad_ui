// @ts-check
// saladui/components/carousel.js
import Component from "../core/component";
import SaladUI from "../index";

/**
 * Get the next slide index given navigation direction and boundaries.
 *
 * @param {number} current - Current slide index
 * @param {number} total - Total number of slides
 * @param {"next"|"prev"} direction - Navigation direction
 * @param {boolean} loop - Whether to wrap around at boundaries
 * @returns {number} New index, or current if no movement possible
 */
export function getNextIndex(current, total, direction, loop) {
  if (total <= 0) return current;

  if (direction === "next") {
    if (current < total - 1) return current + 1;
    if (loop) return 0;
    return current;
  }

  // direction === "prev"
  if (current > 0) return current - 1;
  if (loop) return total - 1;
  return current;
}

/**
 * Determine swipe direction from touch delta.
 *
 * @param {number} delta - Swipe distance (positive = forward in axis)
 * @param {number} threshold - Minimum distance to register as swipe
 * @returns {"next"|"prev"|null} Swipe direction or null if below threshold
 */
export function detectSwipeDirection(delta, threshold) {
  if (Math.abs(delta) <= threshold) return null;
  return delta < 0 ? "next" : "prev";
}

/**
 * CarouselComponent - slide-based content carousel
 * Handles prev/next navigation, keyboard, touch, and optional auto-play
 */
class CarouselComponent extends Component {
  constructor(el, hookContext) {
    super(el, { hookContext });

    this.content = /** @type {HTMLElement|null} */ (
      this.el.querySelector("[data-part='content']")
    );
    /** @type {HTMLElement[]} */
    this.items = /** @type {HTMLElement[]} */ (
      Array.from(this.el.querySelectorAll("[data-part='carousel-item']"))
    );
    this.currentIndex = 0;
    this.loop = this.options.loop === true;
    this.orientation = this.options.orientation || "horizontal";
    this.autoPlay = this.options.autoPlay === true;
    this.autoPlayInterval = parseInt(
      this.options.autoPlayInterval || "5000",
      10,
    );
    this.autoPlayTimer = null;

    this.config.preventDefaultKeys = [
      "ArrowLeft",
      "ArrowRight",
      "ArrowUp",
      "ArrowDown",
    ];

    this.updateSlidePosition();
  }

  /** @returns {import("../core/types.js").ComponentConfig} */
  getComponentConfig() {
    return {
      stateMachine: {
        idle: {
          transitions: {},
        },
      },
      events: {
        _all: {
          keyMap: {
            ArrowLeft: "goToPrev",
            ArrowRight: "goToNext",
            ArrowUp: "goToPrev",
            ArrowDown: "goToNext",
          },
        },
      },
      ariaConfig: {
        root: {
          all: {
            role: "region",
            roledescription: "carousel",
            label: "Carousel",
          },
        },
      },
    };
  }

  setupComponentEvents() {
    // Previous/Next buttons
    const prevBtn = this.el.querySelector("[data-part='prev-button']");
    const nextBtn = this.el.querySelector("[data-part='next-button']");

    if (prevBtn) {
      prevBtn.addEventListener("click", () => this.goToPrev());
    }
    if (nextBtn) {
      nextBtn.addEventListener("click", () => this.goToNext());
    }

    // Touch support
    this.touchStartX = 0;
    this.touchStartY = 0;

    if (this.content) {
      this.content.addEventListener(
        "touchstart",
        (e) => {
          const te = /** @type {TouchEvent} */ (e);
          this.touchStartX = te.touches[0].clientX;
          this.touchStartY = te.touches[0].clientY;
        },
        { passive: true },
      );

      this.content.addEventListener(
        "touchend",
        (e) => {
          const te = /** @type {TouchEvent} */ (e);
          const deltaX = te.changedTouches[0].clientX - this.touchStartX;
          const deltaY = te.changedTouches[0].clientY - this.touchStartY;

          const isHorizontal = this.orientation === "horizontal";
          const delta = isHorizontal ? deltaX : deltaY;
          const dir = detectSwipeDirection(delta, 50);

          if (dir === "next") this.goToNext();
          else if (dir === "prev") this.goToPrev();
        },
        { passive: true },
      );
    }

    // Auto-play
    if (this.autoPlay) {
      this.startAutoPlay();

      // Pause on hover
      this.el.addEventListener("mouseenter", () => this.stopAutoPlay());
      this.el.addEventListener("mouseleave", () => this.startAutoPlay());
    }

    this.updateButtons();
  }

  goToPrev() {
    const newIndex = getNextIndex(
      this.currentIndex,
      this.items.length,
      "prev",
      this.loop,
    );
    if (newIndex === this.currentIndex) return;

    this.currentIndex = newIndex;
    this.updateSlidePosition();
    this.updateButtons();
    this.pushEvent("slide-changed", { index: this.currentIndex });
  }

  goToNext() {
    const newIndex = getNextIndex(
      this.currentIndex,
      this.items.length,
      "next",
      this.loop,
    );
    if (newIndex === this.currentIndex) return;

    this.currentIndex = newIndex;
    this.updateSlidePosition();
    this.updateButtons();
    this.pushEvent("slide-changed", { index: this.currentIndex });
  }

  updateSlidePosition() {
    if (!this.content) return;

    const isHorizontal = this.orientation === "horizontal";
    const offset = this.currentIndex * -100;

    if (isHorizontal) {
      this.content.style.transform = `translateX(${offset}%)`;
    } else {
      this.content.style.transform = `translateY(${offset}%)`;
    }

    // Update item states
    this.items.forEach((item, i) => {
      item.setAttribute(
        "data-active",
        i === this.currentIndex ? "true" : "false",
      );
      item.setAttribute(
        "aria-hidden",
        i !== this.currentIndex ? "true" : "false",
      );
    });
  }

  updateButtons() {
    const prevBtn = /** @type {HTMLButtonElement|null} */ (
      this.el.querySelector("[data-part='prev-button']")
    );
    const nextBtn = /** @type {HTMLButtonElement|null} */ (
      this.el.querySelector("[data-part='next-button']")
    );

    if (!this.loop) {
      if (prevBtn) prevBtn.disabled = this.currentIndex === 0;
      if (nextBtn)
        nextBtn.disabled = this.currentIndex >= this.items.length - 1;
    }
  }

  startAutoPlay() {
    this.stopAutoPlay();
    this.autoPlayTimer = setInterval(
      () => this.goToNext(),
      this.autoPlayInterval,
    );
  }

  stopAutoPlay() {
    if (this.autoPlayTimer) {
      clearInterval(this.autoPlayTimer);
      this.autoPlayTimer = null;
    }
  }

  beforeDestroy() {
    this.stopAutoPlay();
  }
}

SaladUI.register("carousel", CarouselComponent);

export default CarouselComponent;
