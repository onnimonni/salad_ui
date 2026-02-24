defmodule SaladUI.DataTableTest do
  use ComponentCase

  import SaladUI.DataTable

  describe "data_table/1" do
    test "renders table with rows and columns" do
      assigns = %{
        rows: [
          %{name: "Alice", email: "alice@example.com"},
          %{name: "Bob", email: "bob@example.com"}
        ],
        columns: [
          %{key: :name, label: "Name"},
          %{key: :email, label: "Email"}
        ]
      }

      html =
        rendered_to_string(~H"""
        <.data_table id="test-dt" rows={@rows} columns={@columns} />
        """)

      assert html =~ "Name"
      assert html =~ "Email"
      assert html =~ "Alice"
      assert html =~ "alice@example.com"
      assert html =~ "Bob"
    end

    test "renders empty state" do
      assigns = %{
        columns: [%{key: :name, label: "Name"}]
      }

      html =
        rendered_to_string(~H"""
        <.data_table id="empty-dt" rows={[]} columns={@columns} />
        """)

      assert html =~ "No results."
    end

    test "renders sortable columns" do
      assigns = %{
        rows: [%{name: "Alice"}],
        columns: [%{key: :name, label: "Name", sortable: true}]
      }

      html =
        rendered_to_string(~H"""
        <.data_table
          id="sort-dt"
          rows={@rows}
          columns={@columns}
          sort-by={:name}
          sort-dir="asc"
          on-sort={Phoenix.LiveView.JS.push("sort")}
        />
        """)

      assert html =~ ~s(phx-value-column="name")
      assert html =~ ~s(phx-value-direction="desc")
    end

    test "renders pagination" do
      assigns = %{
        rows: [%{name: "Alice"}],
        columns: [%{key: :name, label: "Name"}]
      }

      html =
        rendered_to_string(~H"""
        <.data_table
          id="page-dt"
          rows={@rows}
          columns={@columns}
          page={1}
          page-size={10}
          total-rows={25}
          on-page-change={Phoenix.LiveView.JS.push("page")}
        />
        """)

      assert html =~ "Previous"
      assert html =~ "Next"
      assert html =~ "Showing 1-10 of 25"
    end
  end
end
