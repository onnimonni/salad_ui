defmodule SaladUI.DatePickerTest do
  use ComponentCase

  import SaladUI.DatePicker

  describe "date_picker/1" do
    test "renders date picker with placeholder" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.date_picker id="test-dp" placeholder="Pick a date" />
        """)

      assert html =~ "Pick a date"
      assert html =~ "text-muted-foreground"
    end

    test "renders with selected date" do
      assigns = %{date: ~D[2024-03-15]}

      html =
        rendered_to_string(~H"""
        <.date_picker id="dp-selected" value={@date} />
        """)

      assert html =~ "March 15, 2024"
    end

    test "renders hidden input for forms" do
      assigns = %{date: ~D[2024-03-15]}

      html =
        rendered_to_string(~H"""
        <.date_picker id="dp-form" value={@date} name="start_date" />
        """)

      assert html =~ ~s(name="start_date")
      assert html =~ ~s(type="hidden")
      assert html =~ "2024-03-15"
    end

    test "renders with custom format" do
      assigns = %{date: ~D[2024-12-25]}

      html =
        rendered_to_string(~H"""
        <.date_picker id="dp-format" value={@date} format="%Y/%m/%d" />
        """)

      assert html =~ "2024/12/25"
    end
  end
end
