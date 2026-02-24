defmodule SaladStorybookWeb.Browser.ContextMenuTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/context_menu"

  describe "context menu" do
    test "renders trigger area", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='context-menu']", minimum: 1))
      |> assert_has(css("[data-part='trigger']", minimum: 1))
    end

    test "menu content is hidden by default", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='context-menu'][data-state='closed']", minimum: 1))
    end
  end
end
