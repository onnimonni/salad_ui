defmodule SaladUI.SpinnerTest do
  use ComponentCase

  import SaladUI.Spinner

  describe "spinner/1" do
    test "renders an SVG spinner" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.spinner />
        """)

      assert html =~ "<svg"
      assert html =~ "animate-spin"
      assert html =~ "role=\"status\""
      assert html =~ "aria-label=\"Loading\""
    end

    test "accepts custom class" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.spinner class="size-8 text-primary" />
        """)

      assert html =~ "size-8"
      assert html =~ "text-primary"
    end
  end
end
