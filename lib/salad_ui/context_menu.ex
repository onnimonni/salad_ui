defmodule SaladUI.ContextMenu do
  @moduledoc """
  A context menu component that appears on right-click.

  Context menus display a list of options when the user right-clicks on a trigger element.
  They mirror the dropdown menu API but use a right-click trigger instead of a click trigger.

  ## Examples:

      <.context_menu id="file-menu">
        <.context_menu_trigger>
          <div class="flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed text-sm">
            Right click here
          </div>
        </.context_menu_trigger>
        <.context_menu_content>
          <.context_menu_item>Back</.context_menu_item>
          <.context_menu_item disabled>Forward</.context_menu_item>
          <.context_menu_separator />
          <.context_menu_item>View Page Source</.context_menu_item>
        </.context_menu_content>
      </.context_menu>
  """
  use SaladUI, :component

  @doc """
  The main context menu component.

  ## Options

  * `:id` - Required unique identifier.
  * `:on-open` - Handler for open event.
  * `:on-close` - Handler for close event.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true, doc: "Unique identifier for the context menu"
  attr :"on-open", :any, default: nil, doc: "Handler for context menu open event"
  attr :"on-close", :any, default: nil, doc: "Handler for context menu close event"
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu(assigns) do
    event_map =
      %{}
      |> add_event_mapping(assigns, "opened", :"on-open")
      |> add_event_mapping(assigns, "closed", :"on-close")

    assigns =
      assigns
      |> assign(:event_map, json(event_map))
      |> assign(
        :options,
        json(%{
          animations: get_animation_config()
        })
      )

    ~H"""
    <div
      id={@id}
      class={classes(["relative inline-block", @class])}
      data-component="context-menu"
      data-state="closed"
      data-event-mappings={@event_map}
      data-options={@options}
      data-part="root"
      phx-hook="SaladUI"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  The trigger area for the context menu (right-click target).
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_trigger(assigns) do
    ~H"""
    <div data-part="trigger" class={classes(["", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  The context menu content that appears on right-click.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_content(assigns) do
    ~H"""
    <div data-part="positioner" class="fixed z-50" hidden>
      <div
        data-part="content"
        class={
          classes([
            "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md",
            "data-[state=open]:animate-in data-[state=closed]:animate-out",
            "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
            "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
            @class
          ])
        }
        {@rest}
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  An item in the context menu.
  """
  attr :class, :string, default: nil
  attr :value, :string, default: nil
  attr :variant, :string, values: ~w(default destructive), default: "default"
  attr :disabled, :boolean, default: false
  attr :"on-select", :any, default: nil, doc: "Handler for item selection"
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_item(assigns) do
    event_map = add_event_mapping(%{}, assigns, "item-selected", :"on-select")
    assigns = assign(assigns, :event_map, json(event_map))

    ~H"""
    <div
      data-part="item"
      data-value={@value}
      data-disabled={@disabled}
      data-event-mappings={@event_map}
      class={
        classes([
          "relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          @variant == "destructive" &&
            "text-destructive focus:bg-destructive/10 focus:text-destructive",
          @class
        ])
      }
      tabindex={if @disabled, do: "-1", else: "0"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  A checkbox item in the context menu.
  """
  attr :class, :string, default: nil
  attr :value, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :"on-checked-change", :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_checkbox_item(assigns) do
    event_map =
      add_event_mapping(%{}, assigns, "checked-changed", :"on-checked-change")

    assigns = assign(assigns, :event_map, json(event_map))

    ~H"""
    <div
      data-part="checkbox-item"
      data-value={@value}
      data-disabled={@disabled}
      data-checked={@checked}
      data-state={(@checked && "checked") || "unchecked"}
      data-event-mappings={@event_map}
      class={
        classes([
          "relative flex cursor-default select-none items-center rounded-sm py-1.5 pr-2 pl-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
          @class
        ])
      }
      tabindex={if @disabled, do: "-1", else: "0"}
      {@rest}
    >
      <span class="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
        <span
          data-part="item-indicator"
          data-state={(@checked && "checked") || "unchecked"}
          hidden={!@checked}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="h-4 w-4"
          >
            <path d="M20 6 9 17l-5-5"></path>
          </svg>
        </span>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  A separator in the context menu.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def context_menu_separator(assigns) do
    ~H"""
    <div
      data-part="separator"
      role="separator"
      class={classes(["-mx-1 my-1 h-px bg-muted", @class])}
      {@rest}
    />
    """
  end

  @doc """
  A label for a section in the context menu.
  """
  attr :class, :string, default: nil
  attr :inset, :boolean, default: false
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_label(assigns) do
    ~H"""
    <div
      data-part="label"
      class={classes(["px-2 py-1.5 text-sm font-semibold", @inset && "pl-8", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  A keyboard shortcut hint in a context menu item.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_shortcut(assigns) do
    ~H"""
    <span
      data-part="shortcut"
      class={classes(["ml-auto text-xs tracking-widest opacity-60", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  A group of related context menu items.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def context_menu_group(assigns) do
    ~H"""
    <div data-part="group" role="group" class={classes([@class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp get_animation_config do
    %{
      "open_to_closed" => %{
        duration: 130,
        target_part: "content"
      }
    }
  end
end
