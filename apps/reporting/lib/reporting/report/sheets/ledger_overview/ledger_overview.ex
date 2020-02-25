defmodule Reporting.Report.Sheets.LedgerOverview do
  alias Elixlsx.Sheet
  alias Reporting.BitsharesClients.ES
  alias Reporting.Report.Sheets.LedgerOverview.Columns.{BalanceChange, BlockTime, Description}
  alias Reporting.Report.Sheets.LedgerOverview.Columns.{BlockNumber, OperationName, TransactionID}

  def sheet(account_name) do
    %Sheet{name: "Legder overview", rows: [headers() | data_rows(account_name)]} |> set_columns_width()
  end

  def set_columns_width(sheet) do
    sheet
    |> Sheet.set_col_width("A", 45)
    |> Sheet.set_col_width("B", 18)
    |> Sheet.set_col_width("C", 15)
    |> Sheet.set_col_width("D", 20)
    |> Sheet.set_col_width("E", 70)
  end

  defp headers,       do: (info_headers() ++ asset_headers()) |> Enum.map(&([&1, bold: true]))
  defp info_headers,  do: ["Transaction ID", "Operation name", "Block number", "Block date & time", "Description"]
  defp asset_headers, do: ["Some asset balance"]

  defp data_rows(account_name), do: ES.invoke("account_history", account_name) |> normalized_data_rows

  defp normalized_data_rows(transactions) when is_list(transactions) do
    Enum.map(transactions, fn %{"_source" => transaction} ->
      %{"operation_type" => operation_number} = transaction

      [
        TransactionID.get(transaction),
        OperationName.get(operation_number),
        BlockNumber  .get(transaction),
        BlockTime    .get(transaction),
        Description  .get(transaction, operation_number),
        BalanceChange.get(transaction, operation_number)
      ]
    end)
  end

  defp normalized_data_rows(_), do: []
end
