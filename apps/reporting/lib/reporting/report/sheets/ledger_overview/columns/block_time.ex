defmodule Reporting.Report.Sheets.LedgerOverview.Columns.BlockTime do
  def get(transaction), do: transaction |> get_in(["block_data", "block_time"]) |> String.replace("T", " ")
end
