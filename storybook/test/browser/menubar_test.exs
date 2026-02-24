defmodule SaladStorybookWeb.Browser.MenubarTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/menubar"

  describe "menubar" do
    test "renders menubar component", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='menubar']", minimum: 1))
    end

    test "contains dropdown menu triggers", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='dropdown-menu']", minimum: 1))
      |> assert_has(css("[data-part='trigger']", minimum: 1))
    end
  end
end
