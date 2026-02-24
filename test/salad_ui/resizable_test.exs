defmodule SaladUI.ResizableTest do
  use ComponentCase

  import SaladUI.Resizable

  describe "resizable_panel_group/1" do
    test "renders panel group with panels and handle" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.resizable_panel_group id="test-resize" direction="horizontal">
          <.resizable_panel default-size={50}>
            <div>Panel One</div>
          </.resizable_panel>
          <.resizable_handle />
          <.resizable_panel default-size={50}>
            <div>Panel Two</div>
          </.resizable_panel>
        </.resizable_panel_group>
        """)

      assert html =~ ~s(id="test-resize")
      assert html =~ ~s(data-component="resizable")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "Panel One"
      assert html =~ "Panel Two"
      assert html =~ ~s(role="separator")
    end

    test "renders vertical layout" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.resizable_panel_group id="vert-resize" direction="vertical">
          <.resizable_panel default-size={50}>Top</.resizable_panel>
          <.resizable_handle />
          <.resizable_panel default-size={50}>Bottom</.resizable_panel>
        </.resizable_panel_group>
        """)

      assert html =~ "flex-col"
      assert html =~ ~s(data-panel-group-direction="vertical")
    end

    test "renders handle with grip indicator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.resizable_handle with-handle={true} />
        """)

      assert html =~ "rounded-sm"
      assert html =~ "<circle"
    end

    test "renders panel with constraints" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.resizable_panel default-size={30} min-size={20} max-size={80} collapsible={true}>
          Content
        </.resizable_panel>
        """)

      assert html =~ ~s(data-default-size="30")
      assert html =~ ~s(data-min-size="20")
      assert html =~ ~s(data-max-size="80")
      assert html =~ "data-collapsible"
    end
  end
end
