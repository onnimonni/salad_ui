defmodule SaladStorybookWeb.Browser.CarouselTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/carousel"

  describe "carousel" do
    test "renders carousel component", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='carousel']", minimum: 1))
    end

    test "renders carousel items", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='carousel-item']", minimum: 1))
    end

    test "has prev and next buttons", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='prev-button']", minimum: 1))
      |> assert_has(css("[data-part='next-button']", minimum: 1))
    end
  end
end
