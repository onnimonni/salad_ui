defmodule Storybook.SaladUIComponents.Empty do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Empty

  def function, do: &Empty.empty/1

  def imports,
    do: [
      {Empty, [empty_media: 1, empty_title: 1, empty_description: 1, empty_content: 1]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        template: """
        <.empty>
          <.empty_media>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-10">
              <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 13.5h3.86a2.25 2.25 0 0 1 2.012 1.244l.256.512a2.25 2.25 0 0 0 2.013 1.244h3.218a2.25 2.25 0 0 0 2.013-1.244l.256-.512a2.25 2.25 0 0 1 2.013-1.244h3.859m-19.5.338V18a2.25 2.25 0 0 0 2.25 2.25h15A2.25 2.25 0 0 0 21.75 18v-4.162c0-.224-.034-.447-.1-.661L19.24 5.338a2.25 2.25 0 0 0-2.15-1.588H6.911a2.25 2.25 0 0 0-2.15 1.588L2.35 13.177a2.25 2.25 0 0 0-.1.661Z" />
            </svg>
          </.empty_media>
          <.empty_title>No results found</.empty_title>
          <.empty_description>Try adjusting your search or filter to find what you're looking for.</.empty_description>
          <.empty_content>
            <button class="inline-flex items-center justify-center rounded-md text-sm font-medium border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground h-9 px-4 py-2">
              Clear filters
            </button>
          </.empty_content>
        </.empty>
        """
      },
      %Variation{
        id: :minimal,
        template: """
        <.empty>
          <.empty_title>Nothing here yet</.empty_title>
          <.empty_description>Get started by creating your first item.</.empty_description>
        </.empty>
        """
      }
    ]
  end
end
