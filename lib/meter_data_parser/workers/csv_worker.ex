defmodule MeterDataParser.Workers.CsvWorker do
  use Oban.Worker, queue: :default

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"filename" => filename}}) do
    File.write("hello.txt", "from oban #{filename}")
    :ok
  end
end
