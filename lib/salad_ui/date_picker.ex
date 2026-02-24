defmodule SaladUI.DatePicker do
  @moduledoc """
  A date picker component that combines Calendar + Popover.

  Displays a button trigger showing the formatted date and opens a calendar
  in a popover for date selection.

  ## Examples:

      <.date_picker
        id="start-date"
        value={@selected_date}
        placeholder="Pick a date"
        on-select={JS.push("date_selected")}
      />
  """
  use SaladUI, :component

  import SaladUI.Button
  import SaladUI.Calendar
  import SaladUI.Popover

  @doc """
  Renders a date picker with calendar popover.

  ## Options

  * `:id` - Required unique identifier.
  * `:value` - Selected date (`Date`) or `nil`.
  * `:placeholder` - Button placeholder. Defaults to `"Pick a date"`.
  * `:format` - Date format string for `Calendar.strftime/2`. Defaults to `"%B %d, %Y"`.
  * `:on-select` - Handler for date selection.
  * `:min` - Minimum selectable date.
  * `:max` - Maximum selectable date.
  * `:disabled-dates` - List of disabled dates.
  * `:name` - Form field name for hidden input.
  * `:mode` - Calendar mode: `"single"` or `"range"`. Defaults to `"single"`.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :value, :any, default: nil
  attr :placeholder, :string, default: "Pick a date"
  attr :format, :string, default: "%B %d, %Y"
  attr :"on-select", :any, default: nil
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :"disabled-dates", :list, default: []
  attr :name, :string, default: nil
  attr :mode, :string, values: ~w(single range), default: "single"
  attr :class, :string, default: nil
  attr :rest, :global

  def date_picker(assigns) do
    formatted =
      case assigns.value do
        %Date{} = d ->
          Calendar.strftime(d, assigns.format)

        {%Date{} = s, %Date{} = e} ->
          "#{Calendar.strftime(s, assigns.format)} - #{Calendar.strftime(e, assigns.format)}"

        {%Date{} = s, nil} ->
          "#{Calendar.strftime(s, assigns.format)} - ..."

        _ ->
          nil
      end

    assigns = assign(assigns, :formatted, formatted)

    ~H"""
    <div class={classes([@class])} {@rest}>
      <input
        :if={@name}
        type="hidden"
        name={@name}
        value={if @value, do: Date.to_iso8601(@value), else: ""}
      />
      <.popover id={@id}>
        <.popover_trigger>
          <.button
            variant="outline"
            class={
              classes([
                "w-[280px] justify-start text-left font-normal",
                !@formatted && "text-muted-foreground"
              ])
            }
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
              class="mr-2 h-4 w-4"
            >
              <path d="M8 2v4" /><path d="M16 2v4" />
              <rect width="18" height="18" x="3" y="4" rx="2" />
              <path d="M3 10h18" />
            </svg>
            {if @formatted, do: @formatted, else: @placeholder}
          </.button>
        </.popover_trigger>
        <.popover_content class="w-auto p-0" align="start">
          <.calendar
            id={"#{@id}-calendar"}
            mode={@mode}
            value={@value}
            min={@min}
            max={@max}
            disabled-dates={assigns[:"disabled-dates"]}
            on-select={assigns[:"on-select"]}
          />
        </.popover_content>
      </.popover>
    </div>
    """
  end
end
