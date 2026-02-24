defmodule SaladUI.Menubar do
  @moduledoc """
  A horizontal menu bar component that coordinates multiple dropdown menus.

  Each menu in the menubar acts as a dropdown menu. The menubar provides
  keyboard navigation between menus and hover-to-switch behavior.

  ## Examples:

      <.menubar id="app-menubar">
        <.menubar_menu id="file-menu">
          <.menubar_trigger>File</.menubar_trigger>
          <.menubar_content>
            <.menubar_item>New Tab</.menubar_item>
            <.menubar_item>New Window</.menubar_item>
            <.menubar_separator />
            <.menubar_item>Print</.menubar_item>
          </.menubar_content>
        </.menubar_menu>
        <.menubar_menu id="edit-menu">
          <.menubar_trigger>Edit</.menubar_trigger>
          <.menubar_content>
            <.menubar_item>Undo</.menubar_item>
            <.menubar_item>Redo</.menubar_item>
          </.menubar_content>
        </.menubar_menu>
      </.menubar>
  """
  use SaladUI, :component

  @doc """
  The root menubar container that coordinates child menus.
  """
  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar(assigns) do
    ~H"""
    <div
      id={@id}
      data-component="menubar"
      data-part="root"
      data-state="idle"
      data-options={json(%{})}
      phx-hook="SaladUI"
      class={
        classes([
          "flex h-9 items-center space-x-1 rounded-md border bg-background p-1 shadow-sm",
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
  A single menu within the menubar. Internally renders as a dropdown-menu.
  """
  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :"on-open", :any, default: nil
  attr :"on-close", :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_menu(assigns) do
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
          animations: %{
            "open_to_closed" => %{duration: 100, target_part: "content"}
          }
        })
      )

    ~H"""
    <div
      id={@id}
      class={classes(["relative inline-block", @class])}
      data-component="dropdown-menu"
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
  The trigger button for a menubar menu.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_trigger(assigns) do
    ~H"""
    <button
      data-part="trigger"
      tabindex="0"
      class={
        classes([
          "flex cursor-default select-none items-center rounded-sm px-3 py-1 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  The content panel for a menubar menu.
  """
  attr :class, :string, default: nil
  attr :side, :string, default: "bottom"
  attr :align, :string, default: "start"
  attr :"side-offset", :integer, default: 8
  attr :"align-offset", :integer, default: 0
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_content(assigns) do
    assigns =
      assign(assigns, %{
        side_offset: assigns[:"side-offset"],
        align_offset: assigns[:"align-offset"]
      })

    ~H"""
    <div
      data-part="positioner"
      data-side={@side}
      data-align={@align}
      data-side-offset={@side_offset}
      data-align-offset={@align_offset}
      class="absolute z-50"
      style="min-width: var(--salad-reference-width)"
      hidden
    >
      <div
        data-part="content"
        class={
          classes([
            "z-50 min-w-[12rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md",
            "data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
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
  A menu item in the menubar.
  """
  attr :class, :string, default: nil
  attr :value, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :inset, :boolean, default: false
  attr :"on-select", :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_item(assigns) do
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
          @inset && "pl-8",
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
  A checkbox item in the menubar.
  """
  attr :class, :string, default: nil
  attr :value, :string, default: nil
  attr :checked, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :"on-checked-change", :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_checkbox_item(assigns) do
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
  A separator between menubar items.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def menubar_separator(assigns) do
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
  A label for a section in the menubar.
  """
  attr :class, :string, default: nil
  attr :inset, :boolean, default: false
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_label(assigns) do
    ~H"""
    <div class={classes(["px-2 py-1.5 text-sm font-semibold", @inset && "pl-8", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  A keyboard shortcut hint for a menubar item.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_shortcut(assigns) do
    ~H"""
    <span class={classes(["ml-auto text-xs tracking-widest text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  A group of related menubar items.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def menubar_group(assigns) do
    ~H"""
    <div data-part="group" role="group" class={classes([@class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
