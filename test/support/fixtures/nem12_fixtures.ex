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
      %{
        "consumption_string" => "1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0",
        "nmi" => "1234567890",
        "timestamp" => ~D[2024-11-24],
        "interval_length" => 30
      }
      |> Map.merge(attrs)
      |> MeterDataParser.NEM12.create_meter_reading()

    meter_reading
  end
end
