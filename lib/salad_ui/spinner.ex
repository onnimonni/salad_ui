defmodule SaladUI.Spinner do
  @moduledoc """
  Loading spinner component.

  Renders an animated SVG spinner with accessibility attributes.

  ## Examples:

      <.spinner />
      <.spinner class="size-6" />
      <.spinner class="size-8 text-primary" />
  """
  use SaladUI, :component

  @doc """
  Renders a spinning loading indicator.

  ## Options

  * `:class` - Additional CSS classes. Use `size-*` to control dimensions.

  ## Examples

      <.spinner />
      <.spinner class="size-8" />
      <.spinner class="size-6 text-primary" />
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def spinner(assigns) do
    ~H"""
    <svg
      class={classes(["size-4 animate-spin text-muted-foreground", @class])}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      role="status"
      aria-label="Loading"
      {@rest}
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
      </circle>
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      >
      </path>
    </svg>
    """
  end
end
