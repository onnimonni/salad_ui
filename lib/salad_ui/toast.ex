defmodule SaladUI.Toast do
  @moduledoc """
  Toast notification components for SaladUI.

  Toasts provide brief, auto-dismissing notifications. The toaster component
  manages toast display and the `put_toast/3` helper sends toasts from LiveView.

  ## Examples:

      # In your layout or root template:
      <.toaster id="toaster" />

      # In your LiveView:
      def handle_event("save", _params, socket) do
        socket = SaladUI.Toast.put_toast(socket, "Settings saved successfully!")
        {:noreply, socket}
      end

      # With options:
      SaladUI.Toast.put_toast(socket, "Error occurred", variant: "destructive", duration: 8000)
  """
  use SaladUI, :component

  @doc """
  Renders the toaster container that manages toast notifications.

  ## Options

  * `:id` - Required unique identifier for the toaster.
  * `:position` - Position on screen. Defaults to `"bottom-right"`.
  * `:duration` - Default auto-dismiss duration in ms. Defaults to `5000`.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, default: "toaster", doc: "Unique identifier for the toaster"

  attr :position, :string,
    values: ~w(top-left top-center top-right bottom-left bottom-center bottom-right),
    default: "bottom-right"

  attr :duration, :integer, default: 5000, doc: "Default auto-dismiss duration in ms"
  attr :class, :string, default: nil
  attr :rest, :global

  def toaster(assigns) do
    assigns =
      assigns
      |> assign(:options, json(%{duration: assigns.duration}))
      |> assign(:position_class, position_classes(assigns.position))

    ~H"""
    <div
      id={@id}
      data-component="toaster"
      data-part="root"
      data-duration={@duration}
      data-options={@options}
      phx-hook="SaladUI"
      class={
        classes([
          "fixed z-[100] flex flex-col gap-2 p-4 pointer-events-none w-full max-w-[420px]",
          "[&>*]:pointer-events-auto",
          @position_class,
          @class
        ])
      }
      {@rest}
    />
    """
  end

  @doc """
  Renders a static toast component for use in templates.

  ## Options

  * `:variant` - Visual variant (default, destructive, success, warning, info).
  * `:class` - Additional CSS classes.
  """
  attr :variant, :string,
    values: ~w(default destructive success warning info),
    default: "default"

  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def toast(assigns) do
    assigns = assign(assigns, :variant_class, toast_variant_class(assigns.variant))

    ~H"""
    <div
      data-part="toast"
      data-variant={@variant}
      role="status"
      aria-live="polite"
      class={
        classes([
          "group pointer-events-auto relative flex w-full items-center justify-between space-x-2 overflow-hidden rounded-md border p-4 pr-6 shadow-lg transition-all",
          @variant_class,
          @class
        ])
      }
      {@rest}
    >
      <div class="grid gap-1">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a toast title.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def toast_title(assigns) do
    ~H"""
    <div class={classes(["text-sm font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a toast description.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def toast_description(assigns) do
    ~H"""
    <div class={classes(["text-sm opacity-90", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a toast action button.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def toast_action(assigns) do
    ~H"""
    <button
      class={
        classes([
          "inline-flex h-8 shrink-0 items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium transition-colors hover:bg-secondary focus:outline-none focus:ring-1 focus:ring-ring disabled:pointer-events-none disabled:opacity-50",
          "group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30 group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground group-[.destructive]:focus:ring-destructive",
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
  Renders a toast close button.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: false

  def toast_close(assigns) do
    ~H"""
    <button
      type="button"
      class={
        classes([
          "absolute right-1 top-1 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none group-hover:opacity-100",
          "group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50",
          @class
        ])
      }
      {@rest}
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <path d="M18 6 6 18" /><path d="m6 6 12 12" />
      </svg>
      <span class="sr-only">Close</span>
    </button>
    """
  end

  @doc """
  Pushes a toast notification from a LiveView.

  ## Options

  * `:title` - Toast title. If only `message` is given, it's used as description.
  * `:variant` - Visual variant (default, destructive, success, warning, info).
  * `:duration` - Auto-dismiss duration in ms.

  ## Examples

      SaladUI.Toast.put_toast(socket, "Saved!")
      SaladUI.Toast.put_toast(socket, "Error", variant: "destructive")
      SaladUI.Toast.put_toast(socket, "Changes saved", title: "Success", variant: "success")
  """
  def put_toast(socket, message, opts \\ []) do
    toast = %{
      id: "toast-#{System.unique_integer([:positive])}",
      title: opts[:title],
      description: message,
      variant: opts[:variant] || "default",
      duration: opts[:duration]
    }

    Phoenix.LiveView.push_event(socket, "add_toast", toast)
  end

  defp position_classes(position) do
    case position do
      "top-left" -> "top-0 left-0"
      "top-center" -> "top-0 left-1/2 -translate-x-1/2"
      "top-right" -> "top-0 right-0"
      "bottom-left" -> "bottom-0 left-0"
      "bottom-center" -> "bottom-0 left-1/2 -translate-x-1/2"
      "bottom-right" -> "bottom-0 right-0"
      _ -> "bottom-0 right-0"
    end
  end

  defp toast_variant_class(variant) do
    case variant do
      "destructive" ->
        "destructive group border-destructive bg-destructive text-destructive-foreground"

      "success" ->
        "border-green-500 bg-green-50 text-green-900 dark:bg-green-950 dark:text-green-100"

      "warning" ->
        "border-yellow-500 bg-yellow-50 text-yellow-900 dark:bg-yellow-950 dark:text-yellow-100"

      "info" ->
        "border-blue-500 bg-blue-50 text-blue-900 dark:bg-blue-950 dark:text-blue-100"

      _ ->
        "border bg-background text-foreground"
    end
  end
end
