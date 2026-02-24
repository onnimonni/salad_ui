defmodule SaladUI.CarouselTest do
  use ComponentCase

  import SaladUI.Carousel

  describe "carousel/1" do
    test "renders carousel with items" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.carousel id="test-carousel">
          <.carousel_content>
            <.carousel_item>Slide 1</.carousel_item>
            <.carousel_item>Slide 2</.carousel_item>
            <.carousel_item>Slide 3</.carousel_item>
          </.carousel_content>
          <.carousel_previous />
          <.carousel_next />
        </.carousel>
        """)

      assert html =~ ~s(id="test-carousel")
      assert html =~ ~s(data-component="carousel")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "Slide 1"
      assert html =~ "Slide 2"
      assert html =~ "Slide 3"
      assert html =~ "Previous slide"
      assert html =~ "Next slide"
    end

    test "renders carousel items with proper roles" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.carousel_item>Content</.carousel_item>
        """)

      assert html =~ ~s(role="group")
      assert html =~ ~s(aria-roledescription="slide")
    end

    test "renders with custom orientation" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.carousel id="vert-carousel" orientation="vertical">
          <.carousel_content>
            <.carousel_item>Slide</.carousel_item>
          </.carousel_content>
        </.carousel>
        """)

      assert html =~ ~s(vertical)
    end
  end
end
