defmodule SaladUI.Calendar do
  @moduledoc """
  A calendar component for date selection.

  Supports single date and date range selection modes. All date math is done
  in pure Elixir using the `Date` module. Month navigation uses `phx-click` events.

  ## Examples:

      <.calendar id="cal" mode="single" value={@selected_date} on-select={JS.push("date_selected")} />

      <.calendar id="range-cal" mode="range" value={@date_range} on-select={JS.push("range_selected")} />
  """
  use SaladUI, :component

  @day_names ~w(Su Mo Tu We Th Fr Sa)

  @doc """
  Renders a calendar for date selection.

  ## Options

  * `:id` - Required unique identifier.
  * `:mode` - Selection mode: `"single"` or `"range"`. Defaults to `"single"`.
  * `:value` - Selected date (`Date`) or range (`{Date, Date}`) or `nil`.
  * `:month` - The month to display. Defaults to current month.
  * `:min` - Minimum selectable date.
  * `:max` - Maximum selectable date.
  * `:disabled-dates` - List of dates that cannot be selected.
  * `:on-select` - Handler for date selection.
  * `:on-month-change` - Handler for month navigation.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :mode, :string, values: ~w(single range), default: "single"
  attr :value, :any, default: nil
  attr :month, :any, default: nil
  attr :min, :any, default: nil
  attr :max, :any, default: nil
  attr :"disabled-dates", :list, default: []
  attr :"on-select", :any, default: nil
  attr :"on-month-change", :any, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def calendar(assigns) do
    today = Date.utc_today()

    display_month =
      cond do
        assigns.month -> assigns.month
        assigns.value && is_struct(assigns.value, Date) -> assigns.value
        assigns.value && is_tuple(assigns.value) -> elem(assigns.value, 0)
        true -> today
      end

    first_of_month = Date.beginning_of_month(display_month)
    # day_of_week: 1=Mon..7=Sun, we want Sunday=0
    start_dow = rem(Date.day_of_week(first_of_month) + 6, 7)
    # We need 6 weeks (42 days) starting from the Sunday before/on the 1st
    start_date = Date.add(first_of_month, -start_dow)
    days = Enum.map(0..41, fn i -> Date.add(start_date, i) end)
    weeks = Enum.chunk_every(days, 7)

    assigns =
      assigns
      |> assign(:today, today)
      |> assign(:display_month, display_month)
      |> assign(:weeks, weeks)
      |> assign(:day_names, @day_names)
      |> assign(:prev_month, first_of_month |> Date.add(-1) |> Date.beginning_of_month())
      |> assign(:next_month, Date.add(Date.end_of_month(display_month), 1))

    ~H"""
    <div id={@id} class={classes(["p-3", @class])} {@rest}>
      <div class="flex flex-col space-y-4 sm:flex-row sm:space-x-4 sm:space-y-0">
        <div class="space-y-4">
          <%!-- Header with month navigation --%>
          <div class="flex justify-center pt-1 relative items-center">
            <button
              type="button"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input hover:bg-accent hover:text-accent-foreground h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100 absolute left-1"
              phx-click={nav_month(@id, @prev_month, assigns[:"on-month-change"])}
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
                <path d="m15 18-6-6 6-6" />
              </svg>
            </button>
            <div class="text-sm font-medium">
              {Calendar.strftime(@display_month, "%B %Y")}
            </div>
            <button
              type="button"
              class="inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input hover:bg-accent hover:text-accent-foreground h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100 absolute right-1"
              phx-click={nav_month(@id, @next_month, assigns[:"on-month-change"])}
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
                <path d="m9 18 6-6-6-6" />
              </svg>
            </button>
          </div>

          <%!-- Day names header --%>
          <table class="w-full border-collapse space-y-1">
            <thead>
              <tr class="flex">
                <th
                  :for={name <- @day_names}
                  class="text-muted-foreground rounded-md w-8 font-normal text-[0.8rem]"
                >
                  {name}
                </th>
              </tr>
            </thead>
            <tbody>
              <tr :for={week <- @weeks} class="flex w-full mt-2">
                <td
                  :for={day <- week}
                  class="relative p-0 text-center text-sm focus-within:relative focus-within:z-20"
                >
                  <button
                    type="button"
                    phx-click={select_date(@id, day, assigns[:"on-select"])}
                    disabled={day_disabled?(day, assigns)}
                    class={
                      classes([
                        "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-8 w-8 p-0 font-normal",
                        day_classes(day, @display_month, @today, @value, @mode)
                      ])
                    }
                  >
                    {day.day}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end

  defp nav_month(id, month, handler) do
    js = JS.push("salad_ui:calendar:month_change", value: %{id: id, month: Date.to_iso8601(month)})

    if handler do
      JS.exec(js, handler)
    else
      js
    end
  end

  defp select_date(id, date, handler) do
    js =
      JS.push("salad_ui:calendar:select",
        value: %{id: id, date: Date.to_iso8601(date)}
      )

    if handler do
      JS.exec(js, handler)
    else
      js
    end
  end

  defp day_disabled?(day, assigns) do
    disabled_dates = assigns[:"disabled-dates"] || []

    cond do
      day in disabled_dates -> true
      assigns.min && Date.before?(day, assigns.min) -> true
      assigns.max && Date.after?(day, assigns.max) -> true
      true -> false
    end
  end

  defp day_classes(day, display_month, today, value, mode) do
    outside? = day.month != display_month.month || day.year != display_month.year
    today? = Date.compare(day, today) == :eq
    selected? = day_selected?(day, value, mode)
    range_middle? = day_in_range_middle?(day, value, mode)

    state_class = day_state_class(outside?, today?, selected?, range_middle?)
    [outside? && "text-muted-foreground opacity-50", state_class]
  end

  defp day_state_class(_outside?, _today?, true = _selected?, _range_middle?) do
    "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground focus:bg-primary focus:text-primary-foreground"
  end

  defp day_state_class(_outside?, true = _today?, _selected?, _range_middle?) do
    "bg-accent text-accent-foreground"
  end

  defp day_state_class(_outside?, _today?, _selected?, true = _range_middle?) do
    "bg-accent text-accent-foreground"
  end

  defp day_state_class(true = _outside?, _today?, _selected?, _range_middle?), do: nil

  defp day_state_class(_outside?, _today?, _selected?, _range_middle?) do
    "hover:bg-accent hover:text-accent-foreground"
  end

  defp day_selected?(day, value, mode) do
    case {mode, value} do
      {"single", %Date{} = v} ->
        Date.compare(day, v) == :eq

      {"range", {%Date{} = s, %Date{} = e}} ->
        Date.compare(day, s) == :eq || Date.compare(day, e) == :eq

      {"range", {%Date{} = s, nil}} ->
        Date.compare(day, s) == :eq

      _ ->
        false
    end
  end

  defp day_in_range_middle?(day, value, mode) do
    case {mode, value} do
      {"range", {%Date{} = s, %Date{} = e}} ->
        Date.after?(day, s) && Date.before?(day, e)

      _ ->
        false
    end
  end
end
