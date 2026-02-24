defmodule Storybook.SaladUIComponents.AspectRatio do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.AspectRatio

  def function, do: &AspectRatio.aspect_ratio/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "16:9 aspect ratio container with an image.",
        template: """
        <.aspect_ratio ratio={16 / 9} class="bg-muted rounded-md">
          <div class="flex items-center justify-center h-full w-full bg-muted rounded-md text-muted-foreground">
            16:9 Aspect Ratio
          </div>
        </.aspect_ratio>
        """
      },
      %Variation{
        id: :square,
        description: "1:1 square aspect ratio.",
        template: """
        <div class="w-[200px]">
          <.aspect_ratio ratio={1.0} class="bg-muted rounded-md">
            <div class="flex items-center justify-center h-full w-full bg-muted rounded-md text-muted-foreground">
              1:1 Square
            </div>
          </.aspect_ratio>
        </div>
        """
      },
      %Variation{
        id: :four_three,
        description: "4:3 aspect ratio.",
        template: """
        <div class="w-[300px]">
          <.aspect_ratio ratio={4 / 3} class="bg-muted rounded-md">
            <div class="flex items-center justify-center h-full w-full bg-muted rounded-md text-muted-foreground">
              4:3 Ratio
            </div>
          </.aspect_ratio>
        </div>
        """
      }
    ]
  end
end
