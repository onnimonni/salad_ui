defmodule SaladUI.Combobox do
  @moduledoc """
  A combobox component that combines Command + Popover for searchable selection.

  Wraps a Popover around a Command palette with a trigger button showing
  the selected value.

  ## Examples:

      <.combobox
        id="framework-select"
        options={[
          %{value: "next", label: "Next.js"},
          %{value: "remix", label: "Remix"},
          %{value: "astro", label: "Astro"},
          %{value: "nuxt", label: "Nuxt.js"}
        ]}
        value={@selected_framework}
        placeholder="Select framework..."
        search-placeholder="Search framework..."
        empty-message="No framework found."
        on-select={JS.push("framework_selected")}
      />
  """
  use SaladUI, :component

  import SaladUI.Button
  import SaladUI.Command
  import SaladUI.Popover

  @doc """
  Renders a combobox (searchable select).

  ## Options

  * `:id` - Required unique identifier.
  * `:options` - List of `%{value: String, label: String}` maps.
  * `:value` - Currently selected value.
  * `:placeholder` - Button placeholder text. Defaults to `"Select..."`.
  * `:search-placeholder` - Search input placeholder. Defaults to `"Search..."`.
  * `:empty-message` - Text when no results found. Defaults to `"No results found."`.
  * `:on-select` - Handler for selection.
  * `:name` - Form field name for hidden input.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :options, :list, default: []
  attr :value, :string, default: nil
  attr :placeholder, :string, default: "Select..."
  attr :"search-placeholder", :string, default: "Search..."
  attr :"empty-message", :string, default: "No results found."
  attr :"on-select", :any, default: nil
  attr :name, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def combobox(assigns) do
    selected_label =
      Enum.find_value(assigns.options, fn opt ->
        if opt.value == assigns.value, do: opt.label
      end)

    assigns =
      assigns
      |> assign(:selected_label, selected_label)
      |> assign(:search_placeholder, assigns[:"search-placeholder"])
      |> assign(:empty_message, assigns[:"empty-message"])

    ~H"""
    <div class={classes([@class])} {@rest}>
      <input :if={@name} type="hidden" name={@name} value={@value || ""} />
      <.popover id={@id}>
        <.popover_trigger>
          <.button
            variant="outline"
            class="w-[200px] justify-between"
            aria-expanded="false"
            role="combobox"
          >
            {if @selected_label, do: @selected_label, else: @placeholder}
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
              class="ml-2 h-4 w-4 shrink-0 opacity-50"
            >
              <path d="m7 15 5 5 5-5" /><path d="m7 9 5-5 5 5" />
            </svg>
          </.button>
        </.popover_trigger>
        <.popover_content class="w-[200px] p-0" align="start">
          <.command id={"#{@id}-command"} class="w-full">
            <.command_input placeholder={@search_placeholder} />
            <.command_empty>
              {@empty_message}
            </.command_empty>
            <.command_list>
              <.command_group heading="Options">
                <.command_item
                  :for={option <- @options}
                  phx-click={@value != option.value && assigns[:"on-select"]}
                  phx-value-value={option.value}
                  phx-value-label={option.label}
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
                    class={classes(["mr-2 h-4 w-4", @value != option.value && "opacity-0"])}
                  >
                    <path d="M20 6 9 17l-5-5" />
                  </svg>
                  {option.label}
                </.command_item>
              </.command_group>
            </.command_list>
          </.command>
        </.popover_content>
      </.popover>
    </div>
    """
  end
end
