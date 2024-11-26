defmodule MeterDataParser.NEM12Test do
  use MeterDataParser.DataCase

  alias MeterDataParser.NEM12

  describe "meter_readings" do
    alias MeterDataParser.NEM12.MeterReading

    import MeterDataParser.NEM12Fixtures

    @interval_values_count 1440
    @invalid_attrs %{timestamp: nil, nmi: nil, consumption_string: ""}

    test "list_meter_readings/0 returns all meter_readings" do
      meter_reading = meter_reading_fixture()
      assert NEM12.list_meter_readings() == [%{meter_reading | consumption_string: nil}]
    end

    test "get_meter_reading!/1 returns the meter_reading with given id" do
      meter_reading = meter_reading_fixture()
      assert NEM12.get_meter_reading!(meter_reading.id) == meter_reading
    end

    test "create_meter_reading/1 with valid data creates a meter_reading" do
      interval_length = 30
      valid_attrs = %{
        timestamp: ~D[2024-11-24],
        nmi: "1234567890",
        interval_length: interval_length,
        consumption_string: "1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0" 
      }

      assert {:ok, %MeterReading{} = meter_reading} = NEM12.create_meter_reading(valid_attrs)
      assert meter_reading.timestamp == ~D[2024-11-24]
      assert meter_reading.nmi == "1234567890"
      assert meter_reading.consumption == List.duplicate(Decimal.new("1.0"), trunc(@interval_values_count / interval_length))
    end

    test "create_meter_reading/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = NEM12.create_meter_reading(@invalid_attrs)
    end

    test "update_meter_reading/2 with valid data updates the meter_reading" do
      meter_reading = meter_reading_fixture()
      interval_length = 15
      update_attrs = %{
        timestamp: ~D[2024-11-25],
        nmi: "1234567891",
        interval_length: interval_length,
        consumption_string: "1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0"
      }

      assert {:ok, %MeterReading{} = meter_reading} = NEM12.update_meter_reading(meter_reading, update_attrs)
      assert meter_reading.timestamp == ~D[2024-11-25]
      assert meter_reading.nmi == "1234567891"
      assert meter_reading.consumption == List.duplicate(Decimal.new("1.0"), trunc(@interval_values_count / interval_length))
    end

    test "update_meter_reading/2 with invalid data returns error changeset" do
      meter_reading = meter_reading_fixture()
      assert {:error, %Ecto.Changeset{}} = NEM12.update_meter_reading(meter_reading, @invalid_attrs)
      assert meter_reading == NEM12.get_meter_reading!(meter_reading.id)
    end

    test "delete_meter_reading/1 deletes the meter_reading" do
      meter_reading = meter_reading_fixture()
      assert {:ok, %MeterReading{}} = NEM12.delete_meter_reading(meter_reading)
      assert_raise Ecto.NoResultsError, fn -> NEM12.get_meter_reading!(meter_reading.id) end
    end

    test "change_meter_reading/1 returns a meter_reading changeset" do
      meter_reading = meter_reading_fixture()
      assert %Ecto.Changeset{} = NEM12.change_meter_reading(meter_reading)
    end
  end
end
