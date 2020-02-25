defmodule Reporting.Report.Sheets.LedgerOverview.Columns.TransactionID do
  # def get(transaction), do: transaction |> get_in(["block_data", "trx_id"])
  def get(transaction) do
    txid            = transaction |> get_in(["block_data", "trx_id"])
    cryptofresh_url = "https://cryptofresh.com/tx/#{txid}"

    {:formula, "HYPERLINK(\"#{cryptofresh_url}\", \"#{txid}\")"}
  end
end
