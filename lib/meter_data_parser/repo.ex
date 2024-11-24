defmodule MeterDataParser.Repo do
  use Ecto.Repo,
    otp_app: :meter_data_parser,
    adapter: Ecto.Adapters.Postgres
end
