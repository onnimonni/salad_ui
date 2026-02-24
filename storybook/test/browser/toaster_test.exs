defmodule SaladStorybookWeb.Browser.ToasterTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/toast"

  describe "toast" do
    test "renders toast elements", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='toast']", minimum: 1))
    end

    test "renders different variants", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-variant='destructive']", minimum: 1))
    end
  end
end
