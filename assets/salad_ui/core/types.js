// @ts-check
/**
 * Shared type definitions for SaladUI framework
 * @module types
 */

/**
 * @typedef {Object} StateHandlers
 * @property {string|Function} [enter] - Handler called when entering state
 * @property {string|Function} [exit] - Handler called when exiting state
 * @property {Object<string, string|Function>} [transitions] - Map of event names to target states
 */

/**
 * State machine config: map of state names to state handlers.
 * Intentionally loose to allow subclass-specific state shapes.
 * @typedef {Object<string, any>} StateMachineConfig
 */

/**
 * Event config for a single state. Contains optional keyMap and mouseMap.
 * @typedef {Object} StateEventConfig
 * @property {Object<string, string>} [keyMap] - Map of key names to action names
 * @property {string} [keyEventTarget] - Part name to attach key listener to
 * @property {Object<string, Object<string, string>>} [mouseMap] - partName -> eventType -> action
 */

/**
 * @typedef {Object<string, Object<string, boolean>>} HiddenConfig
 * Map of state names to part visibility: stateName -> partName -> hidden
 */

/**
 * ARIA config for a single part. Keys are state names (plus "all" for global).
 * @typedef {Object<string, Object<string, string|Function>>} AriaStateConfig
 */

/**
 * @typedef {Object<string, AriaStateConfig>} AriaConfig
 * Map of part names to their ARIA configuration
 */

/**
 * The return type of getComponentConfig().
 * Uses loose types to accommodate the variety of component configs.
 * @typedef {Object} ComponentConfig
 * @property {StateMachineConfig} stateMachine - State machine definition
 * @property {Object<string, StateEventConfig>} [events] - Per-state event handlers
 * @property {HiddenConfig} [hiddenConfig] - Per-state part visibility
 * @property {AriaConfig} [ariaConfig] - Per-part ARIA attributes
 */

/**
 * @typedef {Object} AnimationConfig
 * @property {[string, string, string]} animation - [start, running, end] class strings
 * @property {number} [duration] - Duration in milliseconds
 * @property {string} [target_part] - Part name to animate
 */

/**
 * @typedef {Object} ComponentOptions
 * @property {Object} [hookContext] - Phoenix LiveView hook context
 * @property {string} [initialState] - Initial state machine state
 * @property {boolean} [ignoreItems] - Whether to filter out item parts
 */

/**
 * @typedef {Object} PanelConstraints
 * @property {number} minSize - Minimum panel size in percent
 * @property {number} maxSize - Maximum panel size in percent
 * @property {boolean} collapsible - Whether panel can collapse to 0
 */

/**
 * @typedef {Object} SlotState
 * @property {string} char - The character in this slot (empty string if none)
 * @property {boolean} isActive - Whether the caret should show here
 * @property {boolean} isFilled - Whether the slot has a character
 */

/**
 * @typedef {Object} ResizeResult
 * @property {number} sizeA - New size of panel A in percent
 * @property {number} sizeB - New size of panel B in percent
 */

export {};
