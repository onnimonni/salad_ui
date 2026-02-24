defmodule SaladUI.CalendarTest do
  use ComponentCase

  import SaladUI.Calendar

  describe "calendar/1" do
    test "renders calendar with day grid" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar id="test-cal" month={~D[2024-01-15]} />
        """)

      assert html =~ ~s(id="test-cal")
      assert html =~ "January 2024"
      # Day names
      assert html =~ "Su"
      assert html =~ "Mo"
      assert html =~ "Sa"
      # Days of month (rendered with whitespace)
      assert html =~ "1\n"
      assert html =~ "15\n"
      assert html =~ "31\n"
    end

    test "renders with selected date" do
      assigns = %{selected: ~D[2024-01-15]}

      html =
        rendered_to_string(~H"""
        <.calendar id="cal-selected" month={~D[2024-01-15]} value={@selected} />
        """)

      assert html =~ "bg-primary"
    end

    test "renders range mode" do
      assigns = %{range: {~D[2024-01-10], ~D[2024-01-20]}}

      html =
        rendered_to_string(~H"""
        <.calendar id="cal-range" mode="range" month={~D[2024-01-15]} value={@range} />
        """)

      # Start and end dates should have primary bg
      assert html =~ "bg-primary"
      # Middle dates should have accent bg
      assert html =~ "bg-accent"
    end

    test "renders navigation buttons" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar id="cal-nav" month={~D[2024-06-15]} />
        """)

      assert html =~ "June 2024"
      # Has prev/next buttons
      assert html =~ "phx-click"
    end

    test "defaults to current month when no month given" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.calendar id="cal-default" />
        """)

      today = Date.utc_today()
      assert html =~ Calendar.strftime(today, "%B %Y")
    end
  end
end
