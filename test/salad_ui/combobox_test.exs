defmodule SaladUI.ComboboxTest do
  use ComponentCase

  import SaladUI.Combobox

  describe "combobox/1" do
    test "renders combobox with options" do
      assigns = %{
        options: [
          %{value: "next", label: "Next.js"},
          %{value: "remix", label: "Remix"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.combobox id="test-combo" options={@options} value={nil} placeholder="Select framework..." />
        """)

      assert html =~ "Select framework..."
      assert html =~ "Next.js"
      assert html =~ "Remix"
      assert html =~ ~s(role="combobox")
    end

    test "shows selected value label" do
      assigns = %{
        options: [
          %{value: "next", label: "Next.js"},
          %{value: "remix", label: "Remix"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.combobox id="combo-selected" options={@options} value="next" />
        """)

      assert html =~ "Next.js"
    end

    test "renders hidden input for forms" do
      assigns = %{options: [%{value: "a", label: "A"}]}

      html =
        rendered_to_string(~H"""
        <.combobox id="combo-form" options={@options} value="a" name="my_field" />
        """)

      assert html =~ ~s(name="my_field")
      assert html =~ ~s(type="hidden")
      assert html =~ ~s(value="a")
    end

    test "renders empty message" do
      assigns = %{options: []}

      html =
        rendered_to_string(~H"""
        <.combobox id="combo-empty" options={@options} empty-message="Nothing here" />
        """)

      assert html =~ "Nothing here"
    end
  end
end
