defmodule MeterDataParserWeb.MeterReadingLive.UploadComponent do
  use MeterDataParserWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign(:uploaded_files, [])
      |> allow_upload(:meter_reading_csv, accept: ~w(.csv), max_entries: 10, max_file_size: 1_200_000_000, auto_upload: true)
    }
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :meter_reading_csv, fn %{path: path}, _entry ->
        dest = "#{Path.join(Application.app_dir(:meter_data_parser, "priv/static/uploads"), Path.basename(path))}.csv"
        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.cp!(path, dest)

        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    {:noreply,
      socket
      |> update(:uploaded_files, &(&1 ++ uploaded_files))
      |> put_flash(:info, "Readings uploaded successfully. If data sent is large, it will take a while to process.")
      |> push_patch(to: socket.assigns.patch)
    }
  end
end
