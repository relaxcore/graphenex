defmodule Reporting.Report.Sheets.LedgerOverview.Columns.BlockTime do
  def get(transaction), do: transaction |> get_in(["block_data", "block_time"]) |> normalize_datetime()

  # 2020-10-10T11:11 -> 2020-10-10 11:11
  defp normalize_datetime(datetime), do: datetime |> String.replace("T", " ")
end
