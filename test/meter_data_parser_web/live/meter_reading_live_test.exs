defmodule MeterDataParserWeb.MeterReadingLiveTest do
  use MeterDataParserWeb.ConnCase

  import Phoenix.LiveViewTest
  import MeterDataParser.NEM12Fixtures

  @create_attrs %{
    timestamp: "2024-11-24",
    nmi: "1234567890",
    interval_length: 30,
    consumption_string: "1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0"
  }
  @update_attrs %{
    timestamp: "2024-11-25",
    nmi: "1234567891",
    interval_length: 15,
    consumption_string: "1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0"
  }
  @invalid_attrs %{timestamp: nil, nmi: "", consumption_string: ""}

  defp create_meter_reading(_) do
    meter_reading = meter_reading_fixture()
    %{meter_reading: meter_reading}
  end

  describe "Index" do
    setup [:create_meter_reading]

    test "lists all meter_readings", %{conn: conn, meter_reading: meter_reading} do
      {:ok, _index_live, html} = live(conn, ~p"/meter_readings")

      assert html =~ "Listing Meter readings"
      assert html =~ meter_reading.nmi
    end

    test "saves new meter_reading", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/meter_readings")

      assert index_live |> element("a", "New Meter reading") |> render_click() =~
               "New Meter reading"

      assert_patch(index_live, ~p"/meter_readings/new")

      assert index_live
             |> form("#meter_reading-form", meter_reading: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#meter_reading-form", meter_reading: @create_attrs)
             |> render_submit()

      # assert_patch(index_live, ~p"/meter_readings")

      html = render(index_live)
      # assert html =~ "Meter reading created successfully"
      assert html =~ "1234567890"
    end

    test "updates meter_reading in listing", %{conn: conn, meter_reading: meter_reading} do
      {:ok, index_live, _html} = live(conn, ~p"/meter_readings")

      assert index_live |> element("#meter_readings-#{meter_reading.id} a", "Edit") |> render_click() =~
               "Edit Meter reading"

      assert_patch(index_live, ~p"/meter_readings/#{meter_reading}/edit")

      assert index_live
             |> form("#meter_reading-form", meter_reading: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#meter_reading-form", meter_reading: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/meter_readings")

      html = render(index_live)
      assert html =~ "Meter reading updated successfully"
      assert html =~ "1234567891"
    end

    test "deletes meter_reading in listing", %{conn: conn, meter_reading: meter_reading} do
      {:ok, index_live, _html} = live(conn, ~p"/meter_readings")

      assert index_live |> element("#meter_readings-#{meter_reading.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#meter_readings-#{meter_reading.id}")
    end
  end

  describe "Show" do
    setup [:create_meter_reading]

    test "displays meter_reading", %{conn: conn, meter_reading: meter_reading} do
      {:ok, _show_live, html} = live(conn, ~p"/meter_readings/#{meter_reading}")

      assert html =~ "Show Meter reading"
      assert html =~ meter_reading.nmi
    end

    test "updates meter_reading within modal", %{conn: conn, meter_reading: meter_reading} do
      {:ok, show_live, _html} = live(conn, ~p"/meter_readings/#{meter_reading}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Meter reading"

      assert_patch(show_live, ~p"/meter_readings/#{meter_reading}/show/edit")

      assert show_live
             |> form("#meter_reading-form", meter_reading: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#meter_reading-form", meter_reading: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/meter_readings/#{meter_reading}")

      html = render(show_live)
      assert html =~ "Meter reading updated successfully"
      assert html =~ "1234567891"
    end
  end
end
