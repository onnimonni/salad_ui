defmodule SaladUI.ContextMenuTest do
  use ComponentCase

  import SaladUI.ContextMenu

  describe "context_menu/1" do
    test "renders context menu with trigger and content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.context_menu id="test-ctx">
          <.context_menu_trigger>
            <div>Right click here</div>
          </.context_menu_trigger>
          <.context_menu_content>
            <.context_menu_item>Back</.context_menu_item>
          </.context_menu_content>
        </.context_menu>
        """)

      assert html =~ ~s(id="test-ctx")
      assert html =~ ~s(data-component="context-menu")
      assert html =~ ~s(data-state="closed")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "Right click here"
      assert html =~ "Back"
    end

    test "renders context menu items" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.context_menu_item>Profile</.context_menu_item>
        """)

      assert html =~ ~s(data-part="item")
      assert html =~ "Profile"
    end

    test "renders disabled items" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.context_menu_item disabled>Forward</.context_menu_item>
        """)

      assert html =~ "data-disabled"
      assert html =~ ~s(tabindex="-1")
    end

    test "renders separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.context_menu_separator />
        """)

      assert html =~ ~s(role="separator")
      assert html =~ "h-px"
    end

    test "renders checkbox item" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.context_menu_checkbox_item checked={true}>Bold</.context_menu_checkbox_item>
        """)

      assert html =~ ~s(data-part="checkbox-item")
      assert html =~ ~s(data-state="checked")
      assert html =~ "Bold"
    end

    test "renders label and shortcut" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.context_menu_label>Actions</.context_menu_label>
        """)

      assert html =~ "font-semibold"
      assert html =~ "Actions"
    end
  end
end
