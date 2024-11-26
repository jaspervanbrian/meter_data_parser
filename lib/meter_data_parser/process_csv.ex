defmodule MeterDataParser.ProcessCsv do
  alias Ecto.Multi
  alias MeterDataParser.Repo
  alias MeterDataParser.NEM12.MeterReading

  @interval_values_count 1440

  def read_and_save_data(filename) do
    csv_stream =
      filename
      |> File.stream!([read_ahead: 100_000], 1000)
      |> CSV.decode(field_transform: &String.trim/1)

    csv_stream
    |> Enum.reduce(%{current_nmi_data: nil, reading_multi: Multi.new()},
      fn {:ok, data}, %{current_nmi_data: current_nmi_data, reading_multi: reading_multi} = acc ->
        case Enum.at(data, 0) do
          "200" -> %{acc | current_nmi_data: data}
          "300" ->
            # Pattern match current nmi data, also known as the "200" record
            [_, nmi, _, _, _, _, _, _, interval_length, _] = current_nmi_data

            # Calculate the count of interval values
            {interval_length, _} = Integer.parse(interval_length)
            interval_value_length = trunc(@interval_values_count / interval_length)
            interval_date = Enum.at(data, 1)

            # Parse interval date, then transform from NaiveDateTime to Date
            {:ok, naive_date} = interval_date |> Timex.parse("%Y%m%d", :strftime) 
            timestamp = naive_date |> NaiveDateTime.to_date

            # Consumption string
            consumption_string = Enum.slice(data, 2..(interval_value_length + 1)) |> Enum.join(",")
            attrs = %{
              nmi: nmi,
              consumption_string: consumption_string,
              timestamp: timestamp,
              interval_length: interval_length
            }

            meter_reading_changeset =
              %MeterReading{}
              |> MeterReading.save_changeset(attrs)

            %{
              current_nmi_data: current_nmi_data,
              reading_multi: reading_multi |> Multi.insert("#{nmi}-#{interval_date}", meter_reading_changeset),
            }

          "900" -> reading_multi
          _ -> acc
        end
      end)
    |> Repo.transaction()
  end
end
