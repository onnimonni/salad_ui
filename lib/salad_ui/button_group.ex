defmodule SaladUI.ButtonGroup do
  @moduledoc """
  Button group component for grouping related buttons.

  Connects buttons visually by removing internal border-radius and applying
  shared borders.

  ## Examples:

      <.button_group>
        <.button variant="outline">Left</.button>
        <.button variant="outline">Center</.button>
        <.button variant="outline">Right</.button>
      </.button_group>

      <.button_group orientation="vertical">
        <.button variant="outline">Top</.button>
        <.button variant="outline">Bottom</.button>
      </.button_group>
  """
  use SaladUI, :component

  @doc """
  Renders a button group container.

  ## Options

  * `:orientation` - Layout direction: `"horizontal"` or `"vertical"`. Defaults to `"horizontal"`.
  * `:class` - Additional CSS classes.

  ## Examples

      <.button_group>
        <.button variant="outline">A</.button>
        <.button variant="outline">B</.button>
      </.button_group>
  """
  attr :class, :string, default: nil

  attr :orientation, :string,
    values: ~w(horizontal vertical),
    default: "horizontal",
    doc: "layout direction"

  attr :rest, :global
  slot :inner_block, required: true

  def button_group(assigns) do
    ~H"""
    <div
      role="group"
      class={
        classes([
          "inline-flex",
          orientation_classes(@orientation),
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Visual separator between buttons in a group.

  ## Options

  * `:orientation` - Must match parent group orientation. Defaults to `"horizontal"`.
  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil

  attr :orientation, :string,
    values: ~w(horizontal vertical),
    default: "horizontal",
    doc: "separator direction"

  attr :rest, :global

  def button_group_separator(assigns) do
    ~H"""
    <div
      role="separator"
      class={
        classes([
          "shrink-0 bg-border",
          (@orientation == "horizontal" && "w-[1px] self-stretch") || "h-[1px] self-stretch",
          @class
        ])
      }
      {@rest}
    >
    </div>
    """
  end

  @doc """
  Label text within a button group.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def button_group_text(assigns) do
    ~H"""
    <span
      class={
        classes([
          "inline-flex items-center px-3 text-sm text-muted-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp orientation_classes("horizontal") do
    "[&>*:not(:first-child):not(:last-child)]:rounded-none [&>*:first-child]:rounded-r-none [&>*:last-child]:rounded-l-none [&>*:not(:first-child)]:-ml-px"
  end

  defp orientation_classes("vertical") do
    "flex-col [&>*:not(:first-child):not(:last-child)]:rounded-none [&>*:first-child]:rounded-b-none [&>*:last-child]:rounded-t-none [&>*:not(:first-child)]:-mt-px"
  end
end
