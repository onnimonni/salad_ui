defmodule SaladUI.NavigationMenu do
  @moduledoc """
  A navigation menu component with hover-activated content panels.

  Navigation menus provide top-level site navigation with rich dropdown
  content panels that appear on hover.

  ## Examples:

      <.navigation_menu id="main-nav">
        <.navigation_menu_list>
          <.navigation_menu_item>
            <.navigation_menu_trigger>Getting Started</.navigation_menu_trigger>
            <.navigation_menu_content>
              <ul class="grid gap-3 p-6 md:w-[400px]">
                <li>
                  <.navigation_menu_link href="/docs">
                    Documentation
                  </.navigation_menu_link>
                </li>
              </ul>
            </.navigation_menu_content>
          </.navigation_menu_item>
          <.navigation_menu_item>
            <.navigation_menu_link href="/about">About</.navigation_menu_link>
          </.navigation_menu_item>
        </.navigation_menu_list>
        <.navigation_menu_viewport />
      </.navigation_menu>
  """
  use SaladUI, :component

  @doc """
  The root navigation menu container.
  """
  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu(assigns) do
    ~H"""
    <nav
      id={@id}
      data-component="navigation-menu"
      data-part="root"
      data-state="idle"
      data-options={json(%{})}
      phx-hook="SaladUI"
      class={classes(["relative z-10 flex max-w-max flex-1 items-center justify-center", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </nav>
    """
  end

  @doc """
  The list container for navigation menu items.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_list(assigns) do
    ~H"""
    <ul
      data-part="list"
      class={
        classes([
          "group flex flex-1 list-none items-center justify-center space-x-1",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end

  @doc """
  A navigation menu item that may contain a trigger and content.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_item(assigns) do
    ~H"""
    <li data-part="nav-item" class={classes(["relative", @class])} {@rest}>
      {render_slot(@inner_block)}
    </li>
    """
  end

  @doc """
  The trigger button that opens a navigation content panel.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_trigger(assigns) do
    ~H"""
    <button
      data-part="nav-trigger"
      data-state="closed"
      class={
        classes([
          "group inline-flex h-9 w-max items-center justify-center rounded-md bg-background px-4 py-2 text-sm font-medium transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground focus:outline-none disabled:pointer-events-none disabled:opacity-50 data-[state=open]:bg-accent/50",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
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
        class="relative top-[1px] ml-1 h-3 w-3 transition duration-300 group-data-[state=open]:rotate-180"
        aria-hidden="true"
      >
        <path d="m6 9 6 6 6-6" />
      </svg>
    </button>
    """
  end

  @doc """
  The content panel that appears when a trigger is activated.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def navigation_menu_content(assigns) do
    ~H"""
    <div
      data-part="nav-content"
      hidden
      class={
        classes([
          "left-0 top-0 w-full data-[motion^=from-]:animate-in data-[motion^=to-]:animate-out data-[motion^=from-]:fade-in data-[motion^=to-]:fade-out data-[motion=from-end]:slide-in-from-right-52 data-[motion=from-start]:slide-in-from-left-52 data-[motion=to-end]:slide-out-to-right-52 data-[motion=to-start]:slide-out-to-left-52 md:absolute md:w-auto",
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
  A navigation link.
  """
  attr :class, :string, default: nil
  attr :active, :boolean, default: false
  attr :rest, :global, include: ~w(href navigate patch method)
  slot :inner_block, required: true

  def navigation_menu_link(assigns) do
    ~H"""
    <.link
      class={
        classes([
          "block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
          @active && "bg-accent/50",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  The indicator element that shows under the active trigger.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def navigation_menu_indicator(assigns) do
    ~H"""
    <div
      data-part="indicator"
      hidden
      class={
        classes([
          "top-full z-[1] flex h-1.5 items-end justify-center overflow-hidden transition-transform duration-200",
          @class
        ])
      }
      {@rest}
    >
      <div class="relative top-[60%] h-2 w-2 rotate-45 rounded-tl-sm bg-border shadow-md" />
    </div>
    """
  end

  @doc """
  The viewport container where content panels are displayed.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def navigation_menu_viewport(assigns) do
    ~H"""
    <div class="absolute left-0 top-full flex justify-center">
      <div
        data-part="viewport"
        hidden
        data-state="closed"
        class={
          classes([
            "origin-top-center relative mt-1.5 h-[var(--radix-navigation-menu-viewport-height)] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90 md:w-[var(--radix-navigation-menu-viewport-width)]",
            @class
          ])
        }
        {@rest}
      />
    </div>
    """
  end
end
