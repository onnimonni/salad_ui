defmodule SaladUI.Carousel do
  @moduledoc """
  A carousel component for cycling through content slides.

  Supports keyboard navigation, touch/swipe, optional auto-play, and loop mode.

  ## Examples:

      <.carousel id="my-carousel">
        <.carousel_content>
          <.carousel_item>Slide 1</.carousel_item>
          <.carousel_item>Slide 2</.carousel_item>
          <.carousel_item>Slide 3</.carousel_item>
        </.carousel_content>
        <.carousel_previous />
        <.carousel_next />
      </.carousel>
  """
  use SaladUI, :component

  @doc """
  The root carousel container.

  ## Options

  * `:id` - Required unique identifier.
  * `:orientation` - Slide direction: `"horizontal"` or `"vertical"`. Defaults to `"horizontal"`.
  * `:loop` - Whether to loop back to start. Defaults to `false`.
  * `:auto-play` - Whether to auto-advance slides. Defaults to `false`.
  * `:auto-play-interval` - Auto-play interval in ms. Defaults to `5000`.
  * `:on-slide-change` - Handler for slide changes.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :orientation, :string, values: ~w(horizontal vertical), default: "horizontal"
  attr :loop, :boolean, default: false
  attr :"auto-play", :boolean, default: false
  attr :"auto-play-interval", :integer, default: 5000
  attr :"on-slide-change", :any, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def carousel(assigns) do
    event_map =
      add_event_mapping(%{}, assigns, "slide-changed", :"on-slide-change")

    assigns =
      assigns
      |> assign(:event_map, json(event_map))
      |> assign(
        :options,
        json(%{
          orientation: assigns.orientation,
          loop: assigns.loop,
          autoPlay: assigns[:"auto-play"],
          autoPlayInterval: assigns[:"auto-play-interval"]
        })
      )

    ~H"""
    <div
      id={@id}
      data-component="carousel"
      data-part="root"
      data-state="idle"
      data-event-mappings={@event_map}
      data-options={@options}
      phx-hook="SaladUI"
      class={classes(["relative", @class])}
      tabindex="0"
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  The scrollable container for carousel items.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def carousel_content(assigns) do
    ~H"""
    <div class={classes(["overflow-hidden", @class])} {@rest}>
      <div
        data-part="content"
        class="flex transition-transform duration-300 ease-in-out"
        style="-webkit-backface-visibility: hidden; backface-visibility: hidden;"
      >
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  An individual slide within the carousel.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def carousel_item(assigns) do
    ~H"""
    <div
      data-part="carousel-item"
      role="group"
      aria-roledescription="slide"
      class={classes(["min-w-0 shrink-0 grow-0 basis-full pl-4", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  The previous slide button.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def carousel_previous(assigns) do
    ~H"""
    <button
      type="button"
      data-part="prev-button"
      class={
        classes([
          "absolute h-8 w-8 rounded-full border bg-background shadow-sm flex items-center justify-center hover:bg-accent hover:text-accent-foreground disabled:opacity-50 -left-12 top-1/2 -translate-y-1/2",
          @class
        ])
      }
      {@rest}
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
        <path d="m12 19-7-7 7-7" /><path d="M19 12H5" />
      </svg>
      <span class="sr-only">Previous slide</span>
    </button>
    """
  end

  @doc """
  The next slide button.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def carousel_next(assigns) do
    ~H"""
    <button
      type="button"
      data-part="next-button"
      class={
        classes([
          "absolute h-8 w-8 rounded-full border bg-background shadow-sm flex items-center justify-center hover:bg-accent hover:text-accent-foreground disabled:opacity-50 -right-12 top-1/2 -translate-y-1/2",
          @class
        ])
      }
      {@rest}
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
        <path d="M5 12h14" /><path d="m12 5 7 7-7 7" />
      </svg>
      <span class="sr-only">Next slide</span>
    </button>
    """
  end
end
