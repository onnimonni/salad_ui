defmodule SaladStorybook.FormDemoItem do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "items" do
    field :name, :string
    field :description, :string
    field :material, :string
    field :sellable, :boolean, default: true
    field :virtual, :boolean, default: false
    field :color, :string, default: "red"
    field :scale, :integer, default: 10
    field :toggle, :boolean
    field :style, :string
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :description, :material, :sellable, :color, :scale, :virtual])
    |> validate_required([:name, :description])
  end
end
