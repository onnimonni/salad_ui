defmodule Storybook.SaladUIComponents.Item do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Item

  def function, do: &Item.item/1

  def imports,
    do: [
      {Item,
       [
         item_group: 1,
         item_separator: 1,
         item_media: 1,
         item_content: 1,
         item_title: 1,
         item_description: 1,
         item_actions: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        template: """
        <.item>
          <.item_media>
            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-sm font-medium">JD</div>
          </.item_media>
          <.item_content>
            <.item_title>John Doe</.item_title>
            <.item_description>Software Engineer</.item_description>
          </.item_content>
          <.item_actions>
            <button class="inline-flex items-center justify-center rounded-md text-sm font-medium hover:bg-accent hover:text-accent-foreground h-9 w-9">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
                <path stroke-linecap="round" stroke-linejoin="round" d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10" />
              </svg>
            </button>
          </.item_actions>
        </.item>
        """
      },
      %VariationGroup{
        id: :variants,
        description: "Visual variants.",
        variations: [
          %Variation{
            id: :variant_default,
            template: """
            <.item>
              <.item_content>
                <.item_title>Default variant</.item_title>
              </.item_content>
            </.item>
            """
          },
          %Variation{
            id: :variant_outline,
            template: """
            <.item variant="outline">
              <.item_content>
                <.item_title>Outline variant</.item_title>
              </.item_content>
            </.item>
            """
          },
          %Variation{
            id: :variant_muted,
            template: """
            <.item variant="muted">
              <.item_content>
                <.item_title>Muted variant</.item_title>
              </.item_content>
            </.item>
            """
          }
        ]
      },
      %Variation{
        id: :group_with_separators,
        template: """
        <.item_group class="w-full max-w-md">
          <.item>
            <.item_content>
              <.item_title>Item One</.item_title>
              <.item_description>First item description</.item_description>
            </.item_content>
          </.item>
          <.item_separator />
          <.item>
            <.item_content>
              <.item_title>Item Two</.item_title>
              <.item_description>Second item description</.item_description>
            </.item_content>
          </.item>
          <.item_separator />
          <.item>
            <.item_content>
              <.item_title>Item Three</.item_title>
              <.item_description>Third item description</.item_description>
            </.item_content>
          </.item>
        </.item_group>
        """
      }
    ]
  end
end
