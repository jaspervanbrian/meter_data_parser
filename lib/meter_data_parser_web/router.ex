defmodule MeterDataParserWeb.Router do
  use MeterDataParserWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MeterDataParserWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MeterDataParserWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/meter_readings", MeterReadingLive.Index, :index
    live "/meter_readings/new", MeterReadingLive.Index, :new
    live "/meter_readings/upload", MeterReadingLive.Index, :upload
    live "/meter_readings/:id/edit", MeterReadingLive.Index, :edit

    live "/meter_readings/:id", MeterReadingLive.Show, :show
    live "/meter_readings/:id/show/edit", MeterReadingLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MeterDataParserWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:meter_data_parser, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MeterDataParserWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
