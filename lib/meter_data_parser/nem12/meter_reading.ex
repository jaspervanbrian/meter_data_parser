defmodule MeterDataParser.NEM12.MeterReading do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @required_attrs ~w(nmi timestamp interval_length consumption)a
  @interval_values_count 1440

  schema "meter_readings" do
    field :timestamp, :date
    field :nmi, :string
    field :interval_length, :integer
    field :consumption, {:array, :decimal}
    field :consumption_string, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(meter_reading, attrs) do
    meter_reading
    |> cast(attrs, [:nmi, :timestamp, :interval_length, :consumption_string])
    |> validate_required(@required_attrs)
    |> validate_length(:nmi, is: 10)
    |> validate_inclusion(:interval_length, [5, 15, 30])
    |> unique_constraint([:nmi, :timestamp])
  end

  def save_changeset(meter_reading, attrs) do
    %{"consumption_string" => cs} = attrs |> Jason.encode!() |> Jason.decode!()
    consumption = cs
                  |> String.split(",", trim: true)
                  |> Enum.map(fn c ->
                    c
                    |> String.trim
                    |> Decimal.new()
                  end)

    meter_reading
    |> cast(attrs, [:nmi, :timestamp, :interval_length, :consumption_string])
    |> put_change(:consumption, consumption)
    |> validate_required(@required_attrs)
    |> validate_length(:nmi, is: 10)
    |> validate_inclusion(:interval_length, [5, 15, 30])
    |> validate_change(:interval_length, fn :interval_length, interval_length ->
      correct_interval_val_count = trunc(@interval_values_count / interval_length)
      consumption_count = Enum.count(consumption)

      if correct_interval_val_count == Enum.count(consumption) do
        []
      else
        [consumption_string: "Must contain #{correct_interval_val_count} interval values (you have #{consumption_count}) based on interval length value (#{interval_length})"]
      end
    end)
    |> unique_constraint([:nmi, :timestamp])
  end

  def populate_consumption_string(meter_reading) do
    %{consumption: consumption} = meter_reading

    meter_reading
    |> Map.put(:consumption_string, consumption |> Enum.join(", "))
  end
end
