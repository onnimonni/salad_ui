defmodule Storybook.SaladUIComponents.Kbd do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Kbd

  def function, do: &Kbd.kbd/1

  def imports, do: [{Kbd, [kbd_group: 1]}]

  def variations do
    [
      %Variation{
        id: :single_key,
        slots: ["⌘"]
      },
      %Variation{
        id: :text_key,
        slots: ["Shift"]
      },
      %Variation{
        id: :key_combination,
        template: """
        <.kbd_group>
          <.kbd>⌘</.kbd>
          <.kbd>K</.kbd>
        </.kbd_group>
        """
      },
      %Variation{
        id: :multiple_shortcuts,
        template: """
        <div class="flex items-center gap-4">
          <.kbd_group>
            <.kbd>⌘</.kbd>
            <.kbd>C</.kbd>
          </.kbd_group>
          <span class="text-sm text-muted-foreground">Copy</span>
        </div>
        """
      }
    ]
  end
end
