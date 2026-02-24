defmodule Storybook.SaladUIComponents.InputGroup do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.InputGroup

  def function, do: &InputGroup.input_group/1

  def imports,
    do: [
      {InputGroup, [input_group_addon: 1, input_group_text: 1, input_group_button: 1]}
    ]

  def variations do
    [
      %Variation{
        id: :with_icon,
        template: """
        <.input_group class="w-full max-w-sm">
          <.input_group_addon align="start">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-4">
              <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
            </svg>
          </.input_group_addon>
          <input type="text" placeholder="Search..." class="flex h-9 w-full bg-transparent px-3 py-1 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 border-0 focus-visible:ring-0 focus-visible:ring-offset-0" />
        </.input_group>
        """
      },
      %Variation{
        id: :with_text_prefix,
        template: """
        <.input_group class="w-full max-w-sm">
          <.input_group_text>https://</.input_group_text>
          <input type="text" placeholder="example.com" class="flex h-9 w-full bg-transparent px-3 py-1 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 border-0 focus-visible:ring-0 focus-visible:ring-offset-0" />
        </.input_group>
        """
      },
      %Variation{
        id: :with_button,
        template: """
        <.input_group class="w-full max-w-sm">
          <input type="text" placeholder="Search..." class="flex h-9 w-full bg-transparent px-3 py-1 text-sm outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 border-0 focus-visible:ring-0 focus-visible:ring-offset-0" />
          <.input_group_button>Go</.input_group_button>
        </.input_group>
        """
      }
    ]
  end
end
