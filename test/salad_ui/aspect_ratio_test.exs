defmodule SaladUI.AspectRatioTest do
  use ComponentCase

  import SaladUI.AspectRatio

  describe "aspect_ratio/1" do
    test "renders with default ratio" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.aspect_ratio>
          <img src="/photo.jpg" alt="Photo" />
        </.aspect_ratio>
        """)

      assert html =~ "aspect-ratio: 1.0"
      assert html =~ "relative"
      assert html =~ "w-full"
      assert html =~ "<img"
    end

    test "renders with custom ratio" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.aspect_ratio ratio={16 / 9}>
          <img src="/photo.jpg" alt="Photo" />
        </.aspect_ratio>
        """)

      assert html =~ "aspect-ratio: 1.7777777777777777"
    end

    test "accepts custom class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.aspect_ratio ratio={4 / 3} class="bg-muted rounded-md">
          <div>Content</div>
        </.aspect_ratio>
        """)

      assert html =~ "bg-muted"
      assert html =~ "rounded-md"
    end
  end
end
