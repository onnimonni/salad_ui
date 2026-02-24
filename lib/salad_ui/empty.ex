defmodule SaladUI.Empty do
  @moduledoc """
  Empty state layout component.

  Used to display a placeholder when there is no data to show, guiding users
  toward an action.

  ## Examples:

      <.empty>
        <.empty_media>
          <Heroicons.inbox class="size-10 text-muted-foreground" />
        </.empty_media>
        <.empty_title>No results found</.empty_title>
        <.empty_description>Try adjusting your search or filters.</.empty_description>
        <.empty_content>
          <.button variant="outline">Clear filters</.button>
        </.empty_content>
      </.empty>
  """
  use SaladUI, :component

  @doc """
  Root wrapper for the empty state layout.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.empty>
        <.empty_title>Nothing here</.empty_title>
      </.empty>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty(assigns) do
    ~H"""
    <div
      class={
        classes([
          "flex min-h-[200px] flex-col items-center justify-center gap-2 rounded-lg border border-dashed p-8 text-center",
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
  Container for media content (icon, image, avatar) in the empty state.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.empty_media>
        <Heroicons.inbox class="size-10" />
      </.empty_media>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_media(assigns) do
    ~H"""
    <div class={classes(["mb-2 flex items-center justify-center text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Heading for the empty state.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.empty_title>No items</.empty_title>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_title(assigns) do
    ~H"""
    <h3 class={classes(["text-lg font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  @doc """
  Description text for the empty state.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.empty_description>Try a different search term.</.empty_description>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_description(assigns) do
    ~H"""
    <p class={classes(["text-sm text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Actions area for the empty state (buttons, links).

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.empty_content>
        <.button>Create new</.button>
      </.empty_content>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def empty_content(assigns) do
    ~H"""
    <div class={classes(["mt-4 flex items-center gap-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
