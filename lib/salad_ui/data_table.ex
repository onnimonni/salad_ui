defmodule SaladUI.DataTable do
  @moduledoc """
  A data table component that wraps the Table components with sorting,
  filtering, and pagination support.

  Columns are defined as maps with `:key`, `:label`, and optional `:sortable`,
  `:class`, and `:render` fields.

  ## Examples:

      <.data_table
        id="users-table"
        rows={@users}
        columns={[
          %{key: :name, label: "Name", sortable: true},
          %{key: :email, label: "Email", sortable: true},
          %{key: :role, label: "Role"}
        ]}
        sort-by={@sort_by}
        sort-dir={@sort_dir}
        page={@page}
        page-size={@page_size}
        total-rows={@total_rows}
        on-sort={JS.push("sort")}
        on-page-change={JS.push("page_change")}
      />
  """
  use SaladUI, :component

  import SaladUI.Button
  import SaladUI.Table

  @doc """
  Renders a data table with sorting and pagination.

  ## Options

  * `:id` - Required unique identifier.
  * `:rows` - List of row data maps.
  * `:columns` - List of column definitions `%{key, label, sortable?, class?, render?}`.
  * `:sort-by` - Current sort column key (atom or string).
  * `:sort-dir` - Current sort direction: `"asc"` or `"desc"`.
  * `:page` - Current page (1-based).
  * `:page-size` - Rows per page.
  * `:total-rows` - Total number of rows (for pagination).
  * `:selectable` - Whether rows are selectable. Defaults to `false`.
  * `:selected-rows` - List of selected row identifiers.
  * `:on-sort` - Handler for sort changes.
  * `:on-page-change` - Handler for page changes.
  * `:on-select` - Handler for row selection changes.
  * `:class` - Additional CSS classes.
  """
  attr :id, :string, required: true
  attr :rows, :list, default: []
  attr :columns, :list, default: []
  attr :"sort-by", :any, default: nil
  attr :"sort-dir", :string, values: ~w(asc desc), default: "asc"
  attr :page, :integer, default: 1
  attr :"page-size", :integer, default: 10
  attr :"total-rows", :integer, default: 0
  attr :selectable, :boolean, default: false
  attr :"selected-rows", :list, default: []
  attr :"on-sort", :any, default: nil
  attr :"on-page-change", :any, default: nil
  attr :"on-select", :any, default: nil
  attr :class, :string, default: nil
  attr :rest, :global

  def data_table(assigns) do
    total_pages =
      if assigns[:"page-size"] > 0 do
        ceil(assigns[:"total-rows"] / assigns[:"page-size"])
      else
        1
      end

    assigns =
      assigns
      |> assign(:total_pages, total_pages)
      |> assign(:sort_by, assigns[:"sort-by"])
      |> assign(:sort_dir, assigns[:"sort-dir"])
      |> assign(:page_size, assigns[:"page-size"])
      |> assign(:total_rows, assigns[:"total-rows"])

    ~H"""
    <div id={@id} class={classes(["space-y-4", @class])} {@rest}>
      <div class="rounded-md border">
        <.table>
          <.table_header>
            <.table_row>
              <.table_head :for={col <- @columns}>
                <%= if Map.get(col, :sortable) && assigns[:"on-sort"] do %>
                  <button
                    type="button"
                    class="flex items-center gap-1 hover:text-foreground"
                    phx-click={assigns[:"on-sort"]}
                    phx-value-column={col.key}
                    phx-value-direction={next_sort_dir(@sort_by, @sort_dir, col.key)}
                  >
                    {col.label}
                    <.sort_indicator column={col.key} sort_by={@sort_by} sort_dir={@sort_dir} />
                  </button>
                <% else %>
                  {col.label}
                <% end %>
              </.table_head>
            </.table_row>
          </.table_header>
          <.table_body>
            <%= if Enum.empty?(@rows) do %>
              <.table_row>
                <.table_cell class="h-24 text-center text-muted-foreground">
                  <span class="col-span-full">No results.</span>
                </.table_cell>
              </.table_row>
            <% else %>
              <.table_row :for={row <- @rows}>
                <.table_cell :for={col <- @columns} class={Map.get(col, :class)}>
                  <%= if Map.get(col, :render) do %>
                    {col.render.(row)}
                  <% else %>
                    {Map.get(row, col.key)}
                  <% end %>
                </.table_cell>
              </.table_row>
            <% end %>
          </.table_body>
        </.table>
      </div>

      <%!-- Pagination --%>
      <div :if={@total_pages > 1} class="flex items-center justify-between px-2">
        <div class="text-sm text-muted-foreground">
          {page_info_text(@page, @page_size, @total_rows)}
        </div>
        <div class="flex items-center space-x-2">
          <.button
            variant="outline"
            size="sm"
            disabled={@page <= 1}
            phx-click={assigns[:"on-page-change"]}
            phx-value-page={@page - 1}
          >
            Previous
          </.button>
          <.button
            variant="outline"
            size="sm"
            disabled={@page >= @total_pages}
            phx-click={assigns[:"on-page-change"]}
            phx-value-page={@page + 1}
          >
            Next
          </.button>
        </div>
      </div>
    </div>
    """
  end

  attr :column, :any, required: true
  attr :sort_by, :any, default: nil
  attr :sort_dir, :string, default: "asc"

  defp sort_indicator(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      class="h-4 w-4"
    >
      <%= if to_string(@sort_by) == to_string(@column) do %>
        <%= if @sort_dir == "asc" do %>
          <path d="m5 12 7-7 7 7" /><path d="M12 19V5" />
        <% else %>
          <path d="M12 5v14" /><path d="m19 12-7 7-7-7" />
        <% end %>
      <% else %>
        <path d="m7 15 5 5 5-5" /><path d="m7 9 5-5 5 5" />
      <% end %>
    </svg>
    """
  end

  defp next_sort_dir(sort_by, sort_dir, column) do
    if to_string(sort_by) == to_string(column) do
      if sort_dir == "asc", do: "desc", else: "asc"
    else
      "asc"
    end
  end

  defp page_info_text(page, page_size, total_rows) do
    start_row = (page - 1) * page_size + 1
    end_row = min(page * page_size, total_rows)
    "Showing #{start_row}-#{end_row} of #{total_rows}"
  end
end
