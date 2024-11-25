defmodule MeterDataParserWeb.PageController do
  use MeterDataParserWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)

    redirect(conn, to: ~p"/meter_readings")
  end
end
