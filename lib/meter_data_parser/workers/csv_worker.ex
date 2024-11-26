defmodule MeterDataParser.Workers.CsvWorker do
  use Oban.Worker, queue: :default

  alias MeterDataParser.ProcessCsv

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"filename" => filename}}) do
    ProcessCsv.read_and_save_data(filename)

    :ok
  end
end
