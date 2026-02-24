defmodule Storybook.SaladUIComponents.ButtonGroup do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.ButtonGroup

  def function, do: &ButtonGroup.button_group/1

  def imports,
    do: [
      {ButtonGroup, [button_group_separator: 1, button_group_text: 1]},
      {SaladUI.Button, [button: 1]}
    ]

  def variations do
    [
      %Variation{
        id: :horizontal,
        template: """
        <.button_group>
          <.button variant="outline">Left</.button>
          <.button variant="outline">Center</.button>
          <.button variant="outline">Right</.button>
        </.button_group>
        """
      },
      %Variation{
        id: :vertical,
        template: """
        <.button_group orientation="vertical">
          <.button variant="outline">Top</.button>
          <.button variant="outline">Middle</.button>
          <.button variant="outline">Bottom</.button>
        </.button_group>
        """
      },
      %Variation{
        id: :with_separator,
        template: """
        <.button_group>
          <.button variant="outline">Save</.button>
          <.button_group_separator />
          <.button variant="outline">Cancel</.button>
        </.button_group>
        """
      }
    ]
  end
end
