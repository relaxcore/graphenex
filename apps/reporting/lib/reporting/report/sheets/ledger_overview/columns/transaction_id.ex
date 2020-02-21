defmodule Reporting.Report.Sheets.LedgerOverview.Columns.TransactionID do
  def get(transaction), do: transaction |> get_in(["block_data", "trx_id"])
end
