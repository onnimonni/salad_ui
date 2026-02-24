defmodule Storybook.SaladUIComponents.Calendar do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Calendar, as: Cal

  def function, do: &Cal.calendar/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "A calendar for single date selection.",
        attributes: %{
          id: "cal-default",
          mode: "single",
          month: {:eval, "Date.utc_today()"}
        }
      },
      %Variation{
        id: :with_selection,
        description: "Calendar with a pre-selected date.",
        attributes: %{
          id: "cal-selected",
          mode: "single",
          month: {:eval, "Date.utc_today()"},
          value: {:eval, "Date.utc_today()"}
        }
      }
    ]
  end
end
