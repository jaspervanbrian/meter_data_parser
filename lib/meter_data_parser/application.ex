defmodule MeterDataParser.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MeterDataParserWeb.Telemetry,
      MeterDataParser.Repo,
      {DNSCluster, query: Application.get_env(:meter_data_parser, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MeterDataParser.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MeterDataParser.Finch},
      # Start a worker by calling: MeterDataParser.Worker.start_link(arg)
      # {MeterDataParser.Worker, arg},
      # Start to serve requests, typically the last entry
      MeterDataParserWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MeterDataParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MeterDataParserWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
