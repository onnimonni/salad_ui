defmodule SaladUI.Resizable do
  @moduledoc """
  Resizable panel layout component.

  Provides drag-resizable panels with handles for adjusting panel sizes.

  ## Examples:

      <.resizable_panel_group id="resizable" direction="horizontal" class="max-w-md rounded-lg border">
        <.resizable_panel default-size={50}>
          <div class="flex h-[200px] items-center justify-center p-6">
            <span class="font-semibold">One</span>
          </div>
        </.resizable_panel>
        <.resizable_handle />
        <.resizable_panel default-size={50}>
          <div class="flex h-[200px] items-center justify-center p-6">
            <span class="font-semibold">Two</span>
          </div>
        </.resizable_panel>
      </.resizable_panel_group>
  """
  use SaladUI, :component

  @doc """
  The root resizable panel group container.

  ## Options

  * `:id` - Required unique identifier.
  * `:direction` - Layout direction: `"horizontal"` or `"vertical"`. Defaults to `"horizontal"`.
  * `:on-layout-change` - Handler for layout change events.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :direction, :string, values: ~w(horizontal vertical), default: "horizontal"
  attr :"on-layout-change", :any, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def resizable_panel_group(assigns) do
    event_map =
      add_event_mapping(%{}, assigns, "layout-changed", :"on-layout-change")

    assigns =
      assigns
      |> assign(:event_map, json(event_map))
      |> assign(
        :options,
        json(%{direction: assigns.direction})
      )

    ~H"""
    <div
      id={@id}
      data-component="resizable"
      data-part="root"
      data-state="idle"
      data-event-mappings={@event_map}
      data-options={@options}
      data-panel-group-direction={@direction}
      phx-hook="SaladUI"
      class={
        classes([
          "flex h-full w-full",
          @direction == "vertical" && "flex-col",
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
  A resizable panel within a panel group.

  ## Options

  * `:default-size` - Initial size as percentage. Defaults to `0` (auto-distributed).
  * `:min-size` - Minimum size as percentage. Defaults to `0`.
  * `:max-size` - Maximum size as percentage. Defaults to `100`.
  * `:collapsible` - Whether the panel can collapse to zero. Defaults to `false`.
  * `:class` - Additional CSS classes.
  """
  attr :"default-size", :float, default: 0.0
  attr :"min-size", :float, default: 0.0
  attr :"max-size", :float, default: 100.0
  attr :collapsible, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def resizable_panel(assigns) do
    ~H"""
    <div
      data-part="panel"
      data-default-size={assigns[:"default-size"]}
      data-min-size={assigns[:"min-size"]}
      data-max-size={assigns[:"max-size"]}
      data-collapsible={@collapsible}
      class={classes(["overflow-hidden", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  A drag handle between resizable panels.

  ## Options

  * `:with-handle` - Whether to show a visible grip indicator. Defaults to `false`.
  * `:class` - Additional CSS classes.
  """
  attr :"with-handle", :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global

  def resizable_handle(assigns) do
    ~H"""
    <div
      data-part="handle"
      role="separator"
      tabindex="0"
      class={
        classes([
          "relative flex w-px items-center justify-center bg-border after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1 data-[panel-group-direction=vertical]:h-px data-[panel-group-direction=vertical]:w-full data-[panel-group-direction=vertical]:after:left-0 data-[panel-group-direction=vertical]:after:h-1 data-[panel-group-direction=vertical]:after:w-full data-[panel-group-direction=vertical]:after:-translate-y-1/2 data-[panel-group-direction=vertical]:after:translate-x-0 [&[data-panel-group-direction=vertical]>div]:rotate-90 data-[dragging=true]:bg-ring",
          @class
        ])
      }
      {@rest}
    >
      <div
        :if={assigns[:"with-handle"]}
        class="z-10 flex h-4 w-3 items-center justify-center rounded-sm border bg-border"
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
          class="h-2.5 w-2.5"
        >
          <circle cx="9" cy="12" r="1" /><circle cx="15" cy="12" r="1" />
        </svg>
      </div>
    </div>
    """
  end
end
