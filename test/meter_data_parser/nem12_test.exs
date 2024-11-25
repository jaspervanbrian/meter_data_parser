defmodule MeterDataParser.NEM12Test do
  use MeterDataParser.DataCase

  alias MeterDataParser.NEM12

  describe "meter_readings" do
    alias MeterDataParser.NEM12.MeterReading

    import MeterDataParser.NEM12Fixtures

    @invalid_attrs %{id: nil, timestamp: nil, nmi: nil, consumption: nil}

    test "list_meter_readings/0 returns all meter_readings" do
      meter_reading = meter_reading_fixture()
      assert NEM12.list_meter_readings() == [meter_reading]
    end

    test "get_meter_reading!/1 returns the meter_reading with given id" do
      meter_reading = meter_reading_fixture()
      assert NEM12.get_meter_reading!(meter_reading.id) == meter_reading
    end

    test "create_meter_reading/1 with valid data creates a meter_reading" do
      valid_attrs = %{id: "7488a646-e31f-11e4-aace-600308960662", timestamp: ~D[2024-11-24], nmi: "some nmi", consumption: []}

      assert {:ok, %MeterReading{} = meter_reading} = NEM12.create_meter_reading(valid_attrs)
      assert meter_reading.id == "7488a646-e31f-11e4-aace-600308960662"
      assert meter_reading.timestamp == ~D[2024-11-24]
      assert meter_reading.nmi == "some nmi"
      assert meter_reading.consumption == []
    end

    test "create_meter_reading/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = NEM12.create_meter_reading(@invalid_attrs)
    end

    test "update_meter_reading/2 with valid data updates the meter_reading" do
      meter_reading = meter_reading_fixture()
      update_attrs = %{id: "7488a646-e31f-11e4-aace-600308960668", timestamp: ~D[2024-11-25], nmi: "some updated nmi", consumption: []}

      assert {:ok, %MeterReading{} = meter_reading} = NEM12.update_meter_reading(meter_reading, update_attrs)
      assert meter_reading.id == "7488a646-e31f-11e4-aace-600308960668"
      assert meter_reading.timestamp == ~D[2024-11-25]
      assert meter_reading.nmi == "some updated nmi"
      assert meter_reading.consumption == []
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
