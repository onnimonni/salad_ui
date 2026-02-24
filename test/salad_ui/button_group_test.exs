defmodule SaladUI.ButtonGroupTest do
  use ComponentCase

  import SaladUI.ButtonGroup

  describe "button_group/1" do
    test "renders horizontal group" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button_group>
          <button>A</button>
          <button>B</button>
        </.button_group>
        """)

      assert html =~ "role=\"group\""
      assert html =~ "inline-flex"
      assert html =~ "rounded-r-none"
      assert html =~ "rounded-l-none"
      assert html =~ "A"
      assert html =~ "B"
    end

    test "renders vertical group" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button_group orientation="vertical">
          <button>Top</button>
          <button>Bottom</button>
        </.button_group>
        """)

      assert html =~ "flex-col"
      assert html =~ "rounded-b-none"
      assert html =~ "rounded-t-none"
    end

    test "accepts custom class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button_group class="w-full">
          <button>A</button>
        </.button_group>
        """)

      assert html =~ "w-full"
    end
  end

  describe "button_group_separator/1" do
    test "renders horizontal separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button_group_separator />
        """)

      assert html =~ "role=\"separator\""
      assert html =~ "bg-border"
      assert html =~ "w-[1px]"
    end

    test "renders vertical separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button_group_separator orientation="vertical" />
        """)

      assert html =~ "h-[1px]"
    end
  end

  describe "button_group_text/1" do
    test "renders text label" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.button_group_text>or</.button_group_text>
        """)

      assert html =~ "or"
      assert html =~ "text-muted-foreground"
    end
  end
end
