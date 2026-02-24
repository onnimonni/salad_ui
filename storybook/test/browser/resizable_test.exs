defmodule SaladStorybookWeb.Browser.ResizableTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/resizable"

  describe "resizable panels" do
    test "renders panels and handles", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='resizable']", minimum: 1))
      |> assert_has(css("[data-part='panel']", minimum: 1))
      |> assert_has(css("[data-part='handle']", minimum: 1))
    end

    test "handle has separator role for accessibility", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='handle'][role='separator']", minimum: 1))
    end

    test "handle is focusable via tabindex", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='handle'][tabindex='0']", minimum: 1))
    end
  end
end
