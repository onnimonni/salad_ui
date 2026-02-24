defmodule SaladUI.KbdTest do
  use ComponentCase

  import SaladUI.Kbd

  describe "kbd/1" do
    test "renders a kbd element" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.kbd>⌘</.kbd>
        """)

      assert html =~ "<kbd"
      assert html =~ "⌘"
      assert html =~ "rounded"
      assert html =~ "border"
      assert html =~ "bg-muted"
      assert html =~ "font-mono"
    end

    test "accepts custom class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.kbd class="text-base">K</.kbd>
        """)

      assert html =~ "text-base"
      assert html =~ "K"
    end
  end

  describe "kbd_group/1" do
    test "renders a group of kbd elements" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.kbd_group>
          <.kbd>⌘</.kbd>
          <.kbd>K</.kbd>
        </.kbd_group>
        """)

      assert html =~ "<span"
      assert html =~ "inline-flex"
      assert html =~ "⌘"
      assert html =~ "K"
    end
  end
end
