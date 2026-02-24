defmodule SaladUI.MenubarTest do
  use ComponentCase

  import SaladUI.Menubar

  describe "menubar/1" do
    test "renders menubar with menus" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menubar id="test-menubar">
          <.menubar_menu id="file-menu">
            <.menubar_trigger>File</.menubar_trigger>
            <.menubar_content>
              <.menubar_item>New Tab</.menubar_item>
            </.menubar_content>
          </.menubar_menu>
        </.menubar>
        """)

      assert html =~ ~s(id="test-menubar")
      assert html =~ ~s(data-component="menubar")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "File"
      assert html =~ "New Tab"
    end

    test "renders menu items with shortcuts" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menubar_item>
          New Tab
          <.menubar_shortcut>⌘T</.menubar_shortcut>
        </.menubar_item>
        """)

      assert html =~ "New Tab"
      assert html =~ "⌘T"
      assert html =~ "tracking-widest"
    end

    test "renders separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menubar_separator />
        """)

      assert html =~ ~s(role="separator")
      assert html =~ "h-px"
    end

    test "renders checkbox item" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menubar_checkbox_item checked={true}>Always Show Bookmarks Bar</.menubar_checkbox_item>
        """)

      assert html =~ ~s(data-part="checkbox-item")
      assert html =~ ~s(data-state="checked")
    end

    test "renders label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.menubar_label>Actions</.menubar_label>
        """)

      assert html =~ "font-semibold"
      assert html =~ "Actions"
    end
  end
end
