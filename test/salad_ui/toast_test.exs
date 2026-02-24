defmodule SaladUI.ToastTest do
  use ComponentCase

  import SaladUI.Toast

  describe "toaster/1" do
    test "renders toaster container" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster id="my-toaster" />
        """)

      assert html =~ ~s(id="my-toaster")
      assert html =~ ~s(data-component="toaster")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "z-[100]"
    end

    test "renders with position" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toaster id="toaster-top" position="top-right" />
        """)

      assert html =~ "top-0"
      assert html =~ "right-0"
    end
  end

  describe "toast/1" do
    test "renders static toast" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast>
          <.toast_title>Success</.toast_title>
          <.toast_description>Your changes have been saved.</.toast_description>
        </.toast>
        """)

      assert html =~ "Success"
      assert html =~ "Your changes have been saved."
      assert html =~ ~s(role="status")
    end

    test "renders destructive variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast variant="destructive">
          <.toast_title>Error</.toast_title>
        </.toast>
        """)

      assert html =~ "destructive"
      assert html =~ "Error"
    end

    test "renders toast action" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_action>Undo</.toast_action>
        """)

      assert html =~ "Undo"
      assert html =~ "rounded-md"
    end

    test "renders toast close" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.toast_close />
        """)

      assert html =~ "Close"
      assert html =~ "sr-only"
    end
  end
end
