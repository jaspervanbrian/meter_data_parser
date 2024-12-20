defmodule MeterDataParserWeb.MeterReadingLive.FormComponent do
  use MeterDataParserWeb, :live_component

  alias MeterDataParser.NEM12

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage meter reading records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="meter_reading-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:nmi]} type="text" label="NMI" />
        <.input field={@form[:timestamp]} type="date" label="Timestamp" />
        <.input field={@form[:interval_length]} type="select" label="Interval Length" options={[5,15,30]} />
        <.input field={@form[:consumption_string]} type="textarea" label="Consumption" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Meter reading</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{meter_reading: meter_reading} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(NEM12.change_meter_reading(meter_reading))
     end)}
  end

  @impl true
  def handle_event("validate", %{"meter_reading" => meter_reading_params}, socket) do
    changeset = NEM12.change_meter_reading(socket.assigns.meter_reading, meter_reading_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"meter_reading" => meter_reading_params}, socket) do
    save_meter_reading(socket, socket.assigns.action, meter_reading_params)
  end

  defp save_meter_reading(socket, :edit, meter_reading_params) do
    case NEM12.update_meter_reading(socket.assigns.meter_reading, meter_reading_params) do
      {:ok, meter_reading} ->
        notify_parent({:saved, meter_reading})

        {:noreply,
         socket
         |> put_flash(:info, "Meter reading updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_meter_reading(socket, :new, meter_reading_params) do
    case NEM12.create_meter_reading(meter_reading_params) do
      {:ok, meter_reading} ->
        notify_parent({:saved, meter_reading})

        {:noreply,
         socket
         |> put_flash(:info, "Meter reading created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
