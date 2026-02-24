defmodule SaladUI.NavigationMenuTest do
  use ComponentCase

  import SaladUI.NavigationMenu

  describe "navigation_menu/1" do
    test "renders navigation menu structure" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.navigation_menu id="test-nav">
          <.navigation_menu_list>
            <.navigation_menu_item>
              <.navigation_menu_trigger>Getting Started</.navigation_menu_trigger>
              <.navigation_menu_content>
                <p>Content here</p>
              </.navigation_menu_content>
            </.navigation_menu_item>
          </.navigation_menu_list>
          <.navigation_menu_viewport />
        </.navigation_menu>
        """)

      assert html =~ ~s(id="test-nav")
      assert html =~ ~s(data-component="navigation-menu")
      assert html =~ ~s(phx-hook="SaladUI")
      assert html =~ "Getting Started"
      assert html =~ "Content here"
    end

    test "renders navigation menu link" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.navigation_menu_link href="/docs">Documentation</.navigation_menu_link>
        """)

      assert html =~ "Documentation"
      assert html =~ ~s(href="/docs")
      assert html =~ "hover:bg-accent"
    end

    test "renders active link" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.navigation_menu_link href="/docs" active={true}>Docs</.navigation_menu_link>
        """)

      assert html =~ "bg-accent/50"
    end

    test "renders indicator" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.navigation_menu_indicator />
        """)

      assert html =~ ~s(data-part="indicator")
      assert html =~ "rotate-45"
    end
  end
end
