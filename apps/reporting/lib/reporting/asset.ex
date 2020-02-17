defmodule Reporting.Asset do
  alias Reporting.{Asset, Repo}
  alias Reporting.BitsharesClients.RPC

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "assets" do
    field :asset_id, :string
    field :name, :string
    field :precision, :integer
    field :raw_data, :map

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:name, :asset_id, :precision, :raw_data])
    |> validate_required([:name, :asset_id, :precision, :raw_data])
    |> unique_constraint(:asset_id)
  end

  def sync do
    Task.start_link(fn ->
      asset_ids = 0..50_000 |> Enum.to_list |> Enum.map(&("1.3.#{&1}"))

      raw_object = RPC.invoke("get_objects", [asset_ids])
      objects    = raw_object |> Poison.decode! |> Map.get("result") |> Enum.reject(&is_nil/1)

      Enum.each(objects, fn object ->
        %Asset{name: object["symbol"], precision: object["precision"], raw_data: object, asset_id: object["id"]}
        |> Repo.insert(on_conflict: :nothing)
      end)
    end)
  end
end
