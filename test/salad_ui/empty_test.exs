defmodule SaladUI.EmptyTest do
  use ComponentCase

  import SaladUI.Empty

  describe "empty/1" do
    test "renders empty state container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty>
          <.empty_title>No results</.empty_title>
        </.empty>
        """)

      assert html =~ "border-dashed"
      assert html =~ "No results"
    end
  end

  describe "empty_media/1" do
    test "renders media container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_media>Icon here</.empty_media>
        """)

      assert html =~ "text-muted-foreground"
      assert html =~ "Icon here"
    end
  end

  describe "empty_title/1" do
    test "renders title" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_title>Nothing found</.empty_title>
        """)

      assert html =~ "<h3"
      assert html =~ "font-semibold"
      assert html =~ "Nothing found"
    end
  end

  describe "empty_description/1" do
    test "renders description" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_description>Try again later.</.empty_description>
        """)

      assert html =~ "<p"
      assert html =~ "text-muted-foreground"
      assert html =~ "Try again later."
    end
  end

  describe "empty_content/1" do
    test "renders actions area" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty_content>
          <button>Retry</button>
        </.empty_content>
        """)

      assert html =~ "Retry"
      assert html =~ "mt-4"
    end
  end

  describe "full empty state" do
    test "renders complete empty state" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.empty>
          <.empty_media>📭</.empty_media>
          <.empty_title>No messages</.empty_title>
          <.empty_description>Your inbox is empty.</.empty_description>
          <.empty_content>
            <button>Compose</button>
          </.empty_content>
        </.empty>
        """)

      assert html =~ "No messages"
      assert html =~ "Your inbox is empty."
      assert html =~ "Compose"
    end
  end
end
