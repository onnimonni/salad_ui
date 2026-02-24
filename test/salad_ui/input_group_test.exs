defmodule SaladUI.InputGroupTest do
  use ComponentCase

  import SaladUI.InputGroup

  describe "input_group/1" do
    test "renders input group wrapper" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_group>
          <input type="text" />
        </.input_group>
        """)

      assert html =~ "focus-within:ring-2"
      assert html =~ "border-input"
      assert html =~ "rounded-md"
    end
  end

  describe "input_group_addon/1" do
    test "renders start addon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_group_addon align="start">Icon</.input_group_addon>
        """)

      assert html =~ "pl-3"
      assert html =~ "Icon"
    end

    test "renders end addon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_group_addon align="end">Icon</.input_group_addon>
        """)

      assert html =~ "pr-3"
      assert html =~ "Icon"
    end
  end

  describe "input_group_text/1" do
    test "renders text addon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_group_text>https://</.input_group_text>
        """)

      assert html =~ "https://"
      assert html =~ "bg-muted"
      assert html =~ "border-r"
    end
  end

  describe "input_group_button/1" do
    test "renders button addon" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_group_button>Go</.input_group_button>
        """)

      assert html =~ "<button"
      assert html =~ "Go"
      assert html =~ "border-l"
    end
  end

  describe "full input group" do
    test "renders complete input group" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.input_group>
          <.input_group_addon>@</.input_group_addon>
          <input type="text" placeholder="username" />
        </.input_group>
        """)

      assert html =~ "@"
      assert html =~ "placeholder=\"username\""
      assert html =~ "focus-within:ring-2"
    end
  end
end
