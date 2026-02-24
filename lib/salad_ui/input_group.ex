defmodule SaladUI.InputGroup do
  @moduledoc """
  Input group component for inputs with prefix/suffix addons.

  Wraps an input with optional addons (icons, text, buttons) and applies
  shared border and focus styling.

  ## Examples:

      <.input_group>
        <.input_group_addon align="start">
          <Heroicons.magnifying_glass class="size-4 text-muted-foreground" />
        </.input_group_addon>
        <.input type="text" placeholder="Search..." class="border-0 focus-visible:ring-0" />
      </.input_group>

      <.input_group>
        <.input_group_text>https://</.input_group_text>
        <.input type="text" placeholder="example.com" class="border-0 focus-visible:ring-0" />
      </.input_group>
  """
  use SaladUI, :component

  @doc """
  Wrapper for input with addons.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.input_group>
        <.input type="text" class="border-0 focus-visible:ring-0" />
      </.input_group>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group(assigns) do
    ~H"""
    <div
      class={
        classes([
          "flex items-center rounded-md border border-input ring-offset-background focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2 [&>input]:border-0 [&>input]:focus-visible:ring-0 [&>input]:focus-visible:ring-offset-0",
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
  Addon container for icons or other content.

  ## Options

  * `:align` - Position: `"start"` or `"end"`. Defaults to `"start"`.
  * `:class` - Additional CSS classes.

  ## Examples

      <.input_group_addon align="start">
        <Heroicons.magnifying_glass class="size-4" />
      </.input_group_addon>
  """
  attr :class, :string, default: nil

  attr :align, :string,
    values: ~w(start end),
    default: "start",
    doc: "addon position"

  attr :rest, :global
  slot :inner_block, required: true

  def input_group_addon(assigns) do
    ~H"""
    <div
      class={
        classes([
          "flex items-center justify-center text-muted-foreground",
          (@align == "start" && "pl-3") || "pr-3",
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
  Text label within an input group (e.g. "https://", "$").

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.input_group_text>https://</.input_group_text>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group_text(assigns) do
    ~H"""
    <span
      class={
        classes([
          "flex items-center border-r px-3 text-sm text-muted-foreground bg-muted",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Button within an input group.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.input_group_button>Search</.input_group_button>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def input_group_button(assigns) do
    ~H"""
    <button
      class={
        classes([
          "inline-flex items-center justify-center whitespace-nowrap rounded-r-md border-l bg-muted px-3 text-sm font-medium hover:bg-accent hover:text-accent-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
