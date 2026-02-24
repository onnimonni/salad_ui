defmodule SaladUI.Kbd do
  @moduledoc """
  Keyboard shortcut display component.

  Renders styled `<kbd>` elements for displaying keyboard shortcuts and key combinations.

  ## Examples:

      <.kbd>⌘</.kbd>
      <.kbd>K</.kbd>

      <.kbd_group>
        <.kbd>⌘</.kbd>
        <.kbd>K</.kbd>
      </.kbd_group>
  """
  use SaladUI, :component

  @doc """
  Renders a single keyboard key.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.kbd>⌘</.kbd>
      <.kbd>Shift</.kbd>
      <.kbd class="text-base">Enter</.kbd>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def kbd(assigns) do
    ~H"""
    <kbd
      class={
        classes([
          "pointer-events-none inline-flex h-5 select-none items-center gap-1 rounded border bg-muted px-1.5 font-mono text-[10px] font-medium text-muted-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </kbd>
    """
  end

  @doc """
  Groups multiple `kbd` elements to display a key combination.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.kbd_group>
        <.kbd>⌘</.kbd>
        <.kbd>K</.kbd>
      </.kbd_group>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def kbd_group(assigns) do
    ~H"""
    <span class={classes(["inline-flex items-center gap-0.5", @class])} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end
end
