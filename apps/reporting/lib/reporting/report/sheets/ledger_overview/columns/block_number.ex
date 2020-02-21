defmodule Reporting.Report.Sheets.LedgerOverview.Columns.BlockNumber do
  def get(transaction), do: transaction |> get_in(["block_data", "block_num"])
end
