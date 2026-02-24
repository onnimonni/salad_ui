defmodule SaladUI.Item do
  @moduledoc """
  Generic flex container component for building list items.

  Provides a composable set of sub-components for constructing structured list items
  with media, content, and actions.

  ## Examples:

      <.item>
        <.item_media>
          <.avatar src="/avatar.png" />
        </.item_media>
        <.item_content>
          <.item_title>John Doe</.item_title>
          <.item_description>Software Engineer</.item_description>
        </.item_content>
        <.item_actions>
          <.button variant="ghost" size="icon">Edit</.button>
        </.item_actions>
      </.item>
  """
  use SaladUI, :component

  @doc """
  Root flex container for a list item.

  ## Options

  * `:variant` - Visual style: `"default"`, `"outline"`, or `"muted"`.
  * `:size` - Size: `"default"`, `"sm"`, or `"xs"`.
  * `:class` - Additional CSS classes.

  ## Examples

      <.item>content</.item>
      <.item variant="outline">bordered item</.item>
      <.item size="sm">compact item</.item>
  """
  attr :class, :string, default: nil

  attr :variant, :string,
    values: ~w(default outline muted),
    default: "default",
    doc: "the item variant style"

  attr :size, :string,
    values: ~w(default sm xs),
    default: "default",
    doc: "the item size"

  attr :rest, :global
  slot :inner_block, required: true

  def item(assigns) do
    assigns = assign(assigns, :variant_class, variant(assigns))

    ~H"""
    <div
      class={
        classes([
          "flex items-center gap-3",
          @variant_class,
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
  Groups related items together.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.item_group>
        <.item>Item 1</.item>
        <.item>Item 2</.item>
      </.item_group>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_group(assigns) do
    ~H"""
    <div class={classes(["flex flex-col", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Divider between items.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global

  def item_separator(assigns) do
    ~H"""
    <div role="separator" class={classes(["shrink-0 bg-border h-[1px] w-full", @class])} {@rest}>
    </div>
    """
  end

  @doc """
  Container for media content (icon, image, avatar).

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.item_media>
        <.avatar src="/avatar.png" />
      </.item_media>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_media(assigns) do
    ~H"""
    <div class={classes(["flex shrink-0 items-center justify-center", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Wraps title and description text.

  ## Options

  * `:class` - Additional CSS classes.

  ## Examples

      <.item_content>
        <.item_title>Title</.item_title>
        <.item_description>Description</.item_description>
      </.item_content>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_content(assigns) do
    ~H"""
    <div class={classes(["flex min-w-0 flex-1 flex-col gap-0.5", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Item title text.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_title(assigns) do
    ~H"""
    <span class={classes(["truncate text-sm font-medium", @class])} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Item description text.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_description(assigns) do
    ~H"""
    <span class={classes(["truncate text-xs text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Container for action buttons/links.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_actions(assigns) do
    ~H"""
    <div class={classes(["flex shrink-0 items-center gap-1", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Header area above item content.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_header(assigns) do
    ~H"""
    <div class={classes(["flex items-center gap-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Footer area below item content.

  ## Options

  * `:class` - Additional CSS classes.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def item_footer(assigns) do
    ~H"""
    <div class={classes(["flex items-center gap-2 text-xs text-muted-foreground", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @variants %{
    variant: %{
      "default" => "",
      "outline" => "rounded-lg border p-3",
      "muted" => "rounded-lg bg-muted/50 p-3"
    },
    size: %{
      "default" => "py-3",
      "sm" => "py-2",
      "xs" => "py-1"
    }
  }

  @default_variants %{
    variant: "default",
    size: "default"
  }

  defp variant(props) do
    variants = Map.take(props, ~w(variant size)a)
    variants = Map.merge(@default_variants, variants)

    Enum.map_join(variants, " ", fn {key, value} -> @variants[key][value] end)
  end
end
