defmodule Reporting.Report.Sheets.LedgerOverview.Columns.BlockNumber do
  def get(transaction) do
    block_number = transaction |> get_in(["block_data", "block_num"])
    tx_sequence  = transaction |> get_in(["operation_history", "trx_in_block"])
    dex_url      = "https://wallet.bitshares.org/#/block/#{block_number}/#{tx_sequence}"

    {:formula, "HYPERLINK(\"#{dex_url}\", \"#{block_number}\")"}
  end
end
