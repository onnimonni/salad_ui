defmodule SaladStorybookWeb.Browser.InputOTPTest do
  use SaladStorybookWeb.BrowserCase, async: false

  @story_url "/salad_ui_component/input_otp"

  describe "input OTP" do
    test "renders OTP component with slots", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-component='input-otp']", minimum: 1))
      |> assert_has(css("[data-part='slot']", minimum: 1))
    end

    test "has hidden input for capturing keystrokes", %{session: session} do
      session
      |> visit(@story_url)
      |> assert_has(css("[data-part='hidden-input']", minimum: 1, visible: false))
    end
  end
end
