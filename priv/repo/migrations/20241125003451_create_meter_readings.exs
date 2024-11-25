defmodule MeterDataParser.Repo.Migrations.CreateMeterReadings do
  use Ecto.Migration

  def change do
    create table(:meter_readings, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :nmi, :string, size: 10, null: false
      add :interval_length, :integer, null: false
      add :timestamp, :date, null: false
      add :consumption, {:array, :decimal}, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:meter_readings, [:nmi, :timestamp])
  end
end
