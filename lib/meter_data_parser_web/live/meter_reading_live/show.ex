defmodule MeterDataParserWeb.MeterReadingLive.Show do
  use MeterDataParserWeb, :live_view

  alias MeterDataParser.NEM12

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:meter_reading, NEM12.get_meter_reading!(id))}
  end

  defp page_title(:show), do: "Show Meter reading"
  defp page_title(:edit), do: "Edit Meter reading"
end
