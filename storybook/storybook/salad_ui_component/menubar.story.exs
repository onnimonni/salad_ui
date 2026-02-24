defmodule Storybook.SaladUIComponents.Menubar do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.Menubar

  def function, do: &Menubar.menubar/1

  def imports,
    do: [
      {Menubar,
       [
         menubar_menu: 1,
         menubar_trigger: 1,
         menubar_content: 1,
         menubar_item: 1,
         menubar_separator: 1,
         menubar_shortcut: 1,
         menubar_checkbox_item: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :default,
        description: "A menubar with File, Edit, and View menus.",
        template: """
        <.menubar id="menubar-default">
          <.menubar_menu id="mb-file">
            <.menubar_trigger>File</.menubar_trigger>
            <.menubar_content>
              <.menubar_item>
                New Tab <.menubar_shortcut>⌘T</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item>
                New Window <.menubar_shortcut>⌘N</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item disabled>New Incognito Window</.menubar_item>
              <.menubar_separator />
              <.menubar_item>
                Print... <.menubar_shortcut>⌘P</.menubar_shortcut>
              </.menubar_item>
            </.menubar_content>
          </.menubar_menu>
          <.menubar_menu id="mb-edit">
            <.menubar_trigger>Edit</.menubar_trigger>
            <.menubar_content>
              <.menubar_item>
                Undo <.menubar_shortcut>⌘Z</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item>
                Redo <.menubar_shortcut>⇧⌘Z</.menubar_shortcut>
              </.menubar_item>
              <.menubar_separator />
              <.menubar_item>
                Cut <.menubar_shortcut>⌘X</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item>
                Copy <.menubar_shortcut>⌘C</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item>
                Paste <.menubar_shortcut>⌘V</.menubar_shortcut>
              </.menubar_item>
            </.menubar_content>
          </.menubar_menu>
          <.menubar_menu id="mb-view">
            <.menubar_trigger>View</.menubar_trigger>
            <.menubar_content>
              <.menubar_checkbox_item checked={true}>
                Always Show Bookmarks Bar
              </.menubar_checkbox_item>
              <.menubar_checkbox_item>
                Always Show Full URLs
              </.menubar_checkbox_item>
              <.menubar_separator />
              <.menubar_item inset>
                Reload <.menubar_shortcut>⌘R</.menubar_shortcut>
              </.menubar_item>
            </.menubar_content>
          </.menubar_menu>
        </.menubar>
        """
      }
    ]
  end
end
