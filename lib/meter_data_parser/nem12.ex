defmodule MeterDataParser.NEM12 do
  @moduledoc """
  The NEM12 context.
  """

  import Ecto.Query, warn: false
  alias MeterDataParser.Repo

  alias MeterDataParser.NEM12.MeterReading

  @doc """
  Returns the list of meter_readings.

  ## Examples

      iex> list_meter_readings()
      [%MeterReading{}, ...]

  """
  def list_meter_readings do
    Repo.all(MeterReading)
  end

  @doc """
  Gets a single meter_reading.

  Raises `Ecto.NoResultsError` if the Meter reading does not exist.

  ## Examples

      iex> get_meter_reading!(123)
      %MeterReading{}

      iex> get_meter_reading!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meter_reading!(id) do
    Repo.get!(MeterReading, id)
    |> MeterReading.populate_consumption_string
  end

  @doc """
  Creates a meter_reading.

  ## Examples

      iex> create_meter_reading(%{field: value})
      {:ok, %MeterReading{}}

      iex> create_meter_reading(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meter_reading(attrs \\ %{}) do
    %MeterReading{}
    |> MeterReading.save_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meter_reading.

  ## Examples

      iex> update_meter_reading(meter_reading, %{field: new_value})
      {:ok, %MeterReading{}}

      iex> update_meter_reading(meter_reading, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meter_reading(%MeterReading{} = meter_reading, attrs) do
    meter_reading
    |> MeterReading.save_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meter_reading.

  ## Examples

      iex> delete_meter_reading(meter_reading)
      {:ok, %MeterReading{}}

      iex> delete_meter_reading(meter_reading)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meter_reading(%MeterReading{} = meter_reading) do
    Repo.delete(meter_reading)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meter_reading changes.

  ## Examples

      iex> change_meter_reading(meter_reading)
      %Ecto.Changeset{data: %MeterReading{}}

  """
  def change_meter_reading(%MeterReading{} = meter_reading, attrs \\ %{}) do
    MeterReading.changeset(meter_reading, attrs)
  end
end
