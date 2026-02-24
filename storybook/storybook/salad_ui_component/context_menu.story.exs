defmodule Storybook.SaladUIComponents.ContextMenu do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.ContextMenu

  def function, do: &ContextMenu.context_menu/1

  def imports,
    do: [
      {ContextMenu,
       [
         context_menu_trigger: 1,
         context_menu_content: 1,
         context_menu_item: 1,
         context_menu_separator: 1,
         context_menu_label: 1,
         context_menu_shortcut: 1,
         context_menu_checkbox_item: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "Right-click on the dashed area to open the context menu.",
        template: """
        <.context_menu id="ctx-default">
          <.context_menu_trigger>
            <div class="flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed text-sm">
              Right click here
            </div>
          </.context_menu_trigger>
          <.context_menu_content>
            <.context_menu_item>
              Back
              <.context_menu_shortcut>⌘[</.context_menu_shortcut>
            </.context_menu_item>
            <.context_menu_item disabled>
              Forward
              <.context_menu_shortcut>⌘]</.context_menu_shortcut>
            </.context_menu_item>
            <.context_menu_item>
              Reload
              <.context_menu_shortcut>⌘R</.context_menu_shortcut>
            </.context_menu_item>
            <.context_menu_separator />
            <.context_menu_checkbox_item checked={true}>
              Show Bookmarks Bar
            </.context_menu_checkbox_item>
            <.context_menu_checkbox_item>
              Show Full URLs
            </.context_menu_checkbox_item>
            <.context_menu_separator />
            <.context_menu_item>View Page Source</.context_menu_item>
            <.context_menu_item>Inspect</.context_menu_item>
          </.context_menu_content>
        </.context_menu>
        """
      }
    ]
  end
end
