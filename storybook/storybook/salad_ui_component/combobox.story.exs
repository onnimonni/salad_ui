defmodule Storybook.SaladUIComponents.Combobox do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Combobox

  def function, do: &Combobox.combobox/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "A searchable combobox for selecting from a list.",
        attributes: %{
          id: "combo-default",
          options: [
            %{value: "next", label: "Next.js"},
            %{value: "sveltekit", label: "SvelteKit"},
            %{value: "nuxt", label: "Nuxt.js"},
            %{value: "remix", label: "Remix"},
            %{value: "astro", label: "Astro"}
          ],
          placeholder: "Select framework...",
          "search-placeholder": "Search framework...",
          "empty-message": "No framework found."
        }
      }
    ]
  end
end
