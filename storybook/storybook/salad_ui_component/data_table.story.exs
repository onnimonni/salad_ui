defmodule Storybook.SaladUIComponents.DataTable do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias SaladUI.DataTable

  def function, do: &DataTable.data_table/1

  def variations do
    [
      %Variation{
        id: :default,
        description: "A data table with sortable columns and sample data.",
        attributes: %{
          id: "dt-default",
          rows: [
            %{status: "Success", email: "ken99@yahoo.com", amount: "$316.00"},
            %{status: "Success", email: "abe45@gmail.com", amount: "$242.00"},
            %{status: "Processing", email: "monserrat44@gmail.com", amount: "$837.00"},
            %{status: "Failed", email: "silas22@gmail.com", amount: "$874.00"}
          ],
          columns: [
            %{key: :status, label: "Status", sortable: true},
            %{key: :email, label: "Email", sortable: true},
            %{key: :amount, label: "Amount", class: "text-right"}
          ],
          "sort-by": :status,
          "sort-dir": "asc"
        }
      }
    ]
  end
end
