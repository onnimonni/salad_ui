defmodule SaladStorybookWeb.Browser.NavigationMenuTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/navigation_menu"

  describe "navigation menu" do
    test "renders navigation menu component", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='navigation-menu']", minimum: 1))
    end

    test "nav items are present", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='nav-item']", minimum: 1))
    end

    test "viewport is hidden by default", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='navigation-menu'][data-state='idle']", minimum: 1))
    end
  end
end
