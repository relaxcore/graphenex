defmodule BitsharesReporting.Asset do
  alias BitsharesReporting.{Asset, Repo}
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

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
  end

  def sync do
    Task.start_link(fn ->
      query     = from a in Asset, select: a.asset_id, limit: 1, order_by: [desc: :inserted_at]
      last_id   = query |> Repo.one() |> String.split(".") |> Enum.at(-1) |> String.to_integer
      asset_ids = Enum.to_list(last_id+1..10_000)

      Enum.reduce_while(asset_ids, 0, fn x, _acc ->
        asset_id = "1.3.#{x}"

        raw_object = BitsharesReporting.BitsharesRpcClient.invoke("get_objects", [[asset_id]])
        [object]   = raw_object |> Poison.decode! |> Kernel.get_in(["result"])

        if is_map(object) do
          Repo.insert %Asset{name: object["symbol"], precision: object["precision"], raw_data: object, asset_id: asset_id}
          IO.inspect "Created asset #{asset_id}"
          {:cont, 0}
        else
          IO.inspect "Something wrong with asset #{asset_id}. Probably it does not exist"
          {:halt, 0}
        end
      end)
    end)
  end
end
