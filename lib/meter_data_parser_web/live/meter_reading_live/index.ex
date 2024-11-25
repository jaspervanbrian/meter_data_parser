defmodule MeterDataParserWeb.MeterReadingLive.Index do
  use MeterDataParserWeb, :live_view

  alias MeterDataParser.NEM12
  alias MeterDataParser.NEM12.MeterReading

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :meter_readings, NEM12.list_meter_readings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Meter reading")
    |> assign(:meter_reading, NEM12.get_meter_reading!(id))
    |> allow_upload(:meter_reading_csv, accept: ~w(.csv), max_entries: 10, auto_upload: true)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Meter reading")
    |> assign(:meter_reading, %MeterReading{})
    |> allow_upload(:meter_reading_csv, accept: ~w(.csv), max_entries: 10, auto_upload: true)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Meter readings")
    |> assign(:meter_reading, nil)
    |> allow_upload(:meter_reading_csv, accept: ~w(.csv), max_entries: 10, auto_upload: true)
  end

  defp apply_action(socket, :upload, _params) do
    socket
    |> assign(:page_title, "Upload Meter reading")
    |> assign(:meter_reading, %MeterReading{})
    |> allow_upload(:meter_reading_csv, accept: ~w(.csv), max_entries: 10, auto_upload: true)
  end

  @impl true
  def handle_info({MeterDataParserWeb.MeterReadingLive.FormComponent, {:saved, meter_reading}}, socket) do
    {:noreply, stream_insert(socket, :meter_readings, meter_reading)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    meter_reading = NEM12.get_meter_reading!(id)
    {:ok, _} = NEM12.delete_meter_reading(meter_reading)

    {:noreply, stream_delete(socket, :meter_readings, meter_reading)}
  end
end
