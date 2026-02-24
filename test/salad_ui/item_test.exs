defmodule SaladUI.ItemTest do
  use ComponentCase

  import SaladUI.Item

  describe "item/1" do
    test "renders default item" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item>Content</.item>
        """)

      assert html =~ "flex"
      assert html =~ "items-center"
      assert html =~ "Content"
    end

    test "renders outline variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item variant="outline">Bordered</.item>
        """)

      assert html =~ "border"
      assert html =~ "rounded-lg"
    end

    test "renders muted variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item variant="muted">Muted</.item>
        """)

      assert html =~ "bg-muted/50"
    end

    test "renders sm size" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item size="sm">Small</.item>
        """)

      assert html =~ "py-2"
    end
  end

  describe "item_group/1" do
    test "renders a group" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item_group>
          <.item>One</.item>
          <.item>Two</.item>
        </.item_group>
        """)

      assert html =~ "flex-col"
      assert html =~ "One"
      assert html =~ "Two"
    end
  end

  describe "item_separator/1" do
    test "renders separator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item_separator />
        """)

      assert html =~ "role=\"separator\""
      assert html =~ "bg-border"
    end
  end

  describe "item sub-components" do
    test "renders full item with all parts" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item>
          <.item_media>Avatar</.item_media>
          <.item_content>
            <.item_title>John Doe</.item_title>
            <.item_description>Engineer</.item_description>
          </.item_content>
          <.item_actions>
            <button>Edit</button>
          </.item_actions>
        </.item>
        """)

      assert html =~ "John Doe"
      assert html =~ "Engineer"
      assert html =~ "Edit"
      assert html =~ "Avatar"
    end
  end

  describe "item_header/1" do
    test "renders header" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item_header>Header</.item_header>
        """)

      assert html =~ "Header"
    end
  end

  describe "item_footer/1" do
    test "renders footer" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.item_footer>Footer</.item_footer>
        """)

      assert html =~ "Footer"
      assert html =~ "text-muted-foreground"
    end
  end
end
