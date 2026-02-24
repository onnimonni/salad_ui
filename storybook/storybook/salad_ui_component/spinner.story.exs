defmodule Storybook.SaladUIComponents.Spinner do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  def function, do: &SaladUI.Spinner.spinner/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{}
      },
      %VariationGroup{
        id: :sizes,
        description: "Different sizes using Tailwind size classes.",
        variations: [
          %Variation{
            id: :small,
            attributes: %{class: "size-4"}
          },
          %Variation{
            id: :medium,
            attributes: %{class: "size-6"}
          },
          %Variation{
            id: :large,
            attributes: %{class: "size-8"}
          }
        ]
      },
      %Variation{
        id: :with_text,
        template: """
        <div class="flex items-center gap-2">
          <.spinner class="size-4" />
          <span class="text-sm text-muted-foreground">Loading...</span>
        </div>
        """
      }
    ]
  end
end
