defmodule BitsharesReporting.Repo.Migrations.CreateAssets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :asset_id, :string
      add :precision, :integer
      add :raw_data, :map

      timestamps()
    end

    create index(:assets, [:asset_id])
  end
end
