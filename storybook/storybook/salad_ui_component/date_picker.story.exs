defmodule Storybook.SaladUIComponents.DatePicker do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.DatePicker

  def function, do: &DatePicker.date_picker/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "A date picker with no initial value.",
        attributes: %{
          id: "dp-default",
          placeholder: "Pick a date"
        }
      },
      %Variation{
        id: :with_value,
        description: "A date picker with a pre-selected date.",
        attributes: %{
          id: "dp-with-value",
          value: {:eval, "Date.utc_today()"}
        }
      }
    ]
  end
end
