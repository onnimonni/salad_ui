defmodule SaladUI.AspectRatio do
  @moduledoc """
  A component that displays content within a desired ratio.

  ## Examples:

      <.aspect_ratio ratio={16 / 9} class="bg-muted">
        <img
          src="https://images.unsplash.com/photo-example"
          alt="Photo"
          class="rounded-md object-cover h-full w-full"
        />
      </.aspect_ratio>
  """
  use SaladUI, :component

  @doc """
  Renders a container that maintains a specified aspect ratio.

  ## Options

  * `:ratio` - The desired aspect ratio (width / height). Defaults to `1.0`.
  * `:class` - Additional CSS classes.
  """
  attr :ratio, :float, default: 1.0, doc: "The desired aspect ratio (width / height)"
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def aspect_ratio(assigns) do
    ~H"""
    <div
      style={"aspect-ratio: #{@ratio};"}
      class={classes(["relative w-full overflow-hidden", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
