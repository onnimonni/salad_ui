defmodule SaladUI.Drawer do
  @moduledoc """
  A drawer component that slides in from the bottom of the screen.

  Drawers are similar to sheets but are specifically designed for bottom-anchored
  mobile-friendly interactions with a drag handle indicator.

  ## Examples:

      <.drawer id="my-drawer">
        <.drawer_trigger>
          <.button variant="outline">Open Drawer</.button>
        </.drawer_trigger>
        <.drawer_content>
          <.drawer_header>
            <.drawer_title>Move Goal</.drawer_title>
            <.drawer_description>Set your daily activity goal.</.drawer_description>
          </.drawer_header>
          <div class="p-4">
            <p>Drawer content here</p>
          </div>
          <.drawer_footer>
            <.button>Submit</.button>
            <.drawer_close>
              <.button variant="outline">Cancel</.button>
            </.drawer_close>
          </.drawer_footer>
        </.drawer_content>
      </.drawer>
  """
  use SaladUI, :component

  @doc """
  The main drawer component that manages state and positioning.

  ## Options

  * `:id` - Required unique identifier for the drawer.
  * `:open` - Whether the drawer is initially open. Defaults to `false`.
  * `:on-open` - Handler for drawer open event.
  * `:on-close` - Handler for drawer close event.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true, doc: "Unique identifier for the drawer"
  attr :open, :boolean, default: false, doc: "Whether the drawer is initially open"
  attr :class, :string, default: nil
  attr :"close-on-outside-click", :boolean, default: true
  attr :"on-open", :any, default: nil, doc: "Handler for drawer open event"
  attr :"on-close", :any, default: nil, doc: "Handler for drawer close event"
  attr :rest, :global
  slot :inner_block, required: true

  def drawer(assigns) do
    event_map =
      %{}
      |> add_event_mapping(assigns, "opened", :"on-open")
      |> add_event_mapping(assigns, "closed", :"on-close")

    assigns =
      assigns
      |> assign(:event_map, json(event_map))
      |> assign(:initial_state, if(assigns.open, do: "open", else: "closed"))
      |> assign(
        :options,
        json(%{
          animations: get_animation_config(),
          closeOnOutsideClick: assigns[:"close-on-outside-click"]
        })
      )

    ~H"""
    <div
      id={@id}
      class={classes(["relative inline-block", @class])}
      data-component="dialog"
      data-state={@initial_state}
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
  The trigger element that opens the drawer.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_trigger(assigns) do
    ~H"""
    <div data-part="trigger" data-action="open" class={classes(["", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  The drawer content that appears from the bottom of the screen.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_content(assigns) do
    ~H"""
    <div data-part="content" tabindex="0" hidden>
      <div
        data-part="overlay"
        class="fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
      />
      <div
        data-part="content-panel"
        class={
          classes([
            "fixed inset-x-0 bottom-0 z-50 mt-24 flex h-auto flex-col rounded-t-[10px] border bg-background",
            "data-[state=open]:animate-in data-[state=closed]:animate-out",
            "data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",
            "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
            @class
          ])
        }
        {@rest}
      >
        <div class="mx-auto mt-4 h-2 w-[100px] rounded-full bg-muted"></div>
        <div class="flex flex-col">
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a drawer header section.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_header(assigns) do
    ~H"""
    <div class={classes(["grid gap-1.5 p-4 text-center sm:text-left", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a drawer title.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_title(assigns) do
    ~H"""
    <h3 class={classes(["text-lg font-semibold leading-none tracking-tight", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  @doc """
  Renders a drawer description.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_description(assigns) do
    ~H"""
    <p class={classes(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a drawer footer section.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_footer(assigns) do
    ~H"""
    <div class={classes(["mt-auto flex flex-col gap-2 p-4", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  The close button for the drawer.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def drawer_close(assigns) do
    ~H"""
    <div data-part="close-trigger" data-action="close" class={classes(["", @class])} {@rest}>
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
