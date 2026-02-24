defmodule Storybook.SaladUIComponents.Toast do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Toast

  def function, do: &Toast.toast/1

  def imports,
    do: [
      {Toast,
       [
         toast_title: 1,
         toast_description: 1,
         toast_action: 1,
         toast_close: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "Default toast notification.",
        template: """
        <.toast>
          <.toast_title>Scheduled: Catch up</.toast_title>
          <.toast_description>Friday, February 10, 2023 at 5:57 PM</.toast_description>
        </.toast>
        """
      },
      %Variation{
        id: :destructive,
        description: "Destructive toast for error messages.",
        template: """
        <.toast variant="destructive">
          <.toast_title>Uh oh! Something went wrong.</.toast_title>
          <.toast_description>There was a problem with your request.</.toast_description>
        </.toast>
        """
      },
      %Variation{
        id: :success,
        description: "Success toast variant.",
        template: """
        <.toast variant="success">
          <.toast_title>Success</.toast_title>
          <.toast_description>Your changes have been saved successfully.</.toast_description>
        </.toast>
        """
      },
      %Variation{
        id: :with_action,
        description: "Toast with an action button.",
        template: """
        <.toast>
          <.toast_title>Event has been created</.toast_title>
          <.toast_description>Sunday, December 03, 2023 at 9:00 AM</.toast_description>
          <.toast_action>Undo</.toast_action>
        </.toast>
        """
      }
    ]
  end
end
