defmodule Storybook.SaladUIComponents.Resizable do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Resizable

  def function, do: &Resizable.resizable_panel_group/1

  def imports,
    do: [
      {Resizable,
       [
         resizable_panel: 1,
         resizable_handle: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "Horizontal resizable panels with a drag handle.",
        template: """
        <.resizable_panel_group id="resize-default" direction="horizontal" class="max-w-md rounded-lg border">
          <.resizable_panel default-size={50}>
            <div class="flex h-[200px] items-center justify-center p-6">
              <span class="font-semibold">One</span>
            </div>
          </.resizable_panel>
          <.resizable_handle with-handle={true} />
          <.resizable_panel default-size={50}>
            <div class="flex h-[200px] items-center justify-center p-6">
              <span class="font-semibold">Two</span>
            </div>
          </.resizable_panel>
        </.resizable_panel_group>
        """
      },
      %Variation{
        id: :vertical,
        description: "Vertical resizable panels.",
        template: """
        <.resizable_panel_group id="resize-vertical" direction="vertical" class="max-w-md rounded-lg border">
          <.resizable_panel default-size={25}>
            <div class="flex h-full items-center justify-center p-6">
              <span class="font-semibold">Header</span>
            </div>
          </.resizable_panel>
          <.resizable_handle with-handle={true} />
          <.resizable_panel default-size={75}>
            <div class="flex h-[200px] items-center justify-center p-6">
              <span class="font-semibold">Content</span>
            </div>
          </.resizable_panel>
        </.resizable_panel_group>
        """
      }
    ]
  end
end
