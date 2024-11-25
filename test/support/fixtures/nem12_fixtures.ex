defmodule MeterDataParser.NEM12Fixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MeterDataParser.NEM12` context.
  """

  @doc """
  Generate a meter_reading.
  """
  def meter_reading_fixture(attrs \\ %{}) do
    {:ok, meter_reading} =
      attrs
      |> Enum.into(%{
        consumption: [],
        id: "7488a646-e31f-11e4-aace-600308960662",
        nmi: "some nmi",
        timestamp: ~D[2024-11-24]
      })
      |> MeterDataParser.NEM12.create_meter_reading()

    meter_reading
  end
end
