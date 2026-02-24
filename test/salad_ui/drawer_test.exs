defmodule SaladUI.DrawerTest do
  use ComponentCase

  import SaladUI.Drawer

  describe "drawer/1" do
    test "renders drawer with trigger and content" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.drawer id="test-drawer">
          <.drawer_trigger>
            <button>Open</button>
          </.drawer_trigger>
          <.drawer_content>
            <.drawer_header>
              <.drawer_title>Title</.drawer_title>
              <.drawer_description>Description</.drawer_description>
            </.drawer_header>
          </.drawer_content>
        </.drawer>
        """)

      assert html =~ ~s(id="test-drawer")
      assert html =~ ~s(data-component="dialog")
      assert html =~ ~s(data-state="closed")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "Open"
      assert html =~ "Title"
      assert html =~ "Description"
    end

    test "renders drag handle indicator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.drawer id="handle-drawer">
          <.drawer_content>
            <p>Content</p>
          </.drawer_content>
        </.drawer>
        """)

      assert html =~ "w-[100px]"
      assert html =~ "rounded-full"
      assert html =~ "bg-muted"
    end

    test "renders drawer footer" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.drawer_footer>
          <button>Submit</button>
        </.drawer_footer>
        """)

      assert html =~ "Submit"
      assert html =~ "mt-auto"
    end

    test "renders drawer close" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.drawer_close>
          <button>Cancel</button>
        </.drawer_close>
        """)

      assert html =~ ~s(data-action="close")
      assert html =~ "Cancel"
    end
  end
end
