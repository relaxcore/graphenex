defmodule Reporting.Report do
  require Elixlsx

  alias Reporting.BitsharesClients.ES
  alias Reporting.Report.Columns.{BaseAmount, BaseAssetName, BlockNumber, BlockTime, Description, FeeAmount}
  alias Reporting.Report.Columns.{FeeAssetName, OperationName, QuoteAmount, QuoteAssetName, TransactionID}
  alias Elixlsx.{Sheet, Workbook}

  def generate(_, account_name) when not is_binary(account_name), do: {:error, "Invalid account name format!"}
  def generate(:csv, _),                                          do: {:error, "Not implemented!"}

  def generate(:xlsx, account_name) do
    sheet_name = "#{account_name} report"
    file_path  = "./apps/reporting/generated_reports/#{unix_time()}_#{account_name}.xlsx"

    sheet = %Sheet{name: sheet_name, rows: [headers() | data_rows(account_name)]}
    %Workbook{sheets: [sheet]} |> Elixlsx.write_to(file_path)
  end

  def generate(_, _), do: {:error, "Undefined file format!"}

  defp headers do
    # TODO: bold text style
    ["Operation name", "Description", "Transaction ID", "Block number", "Block date & time", "Base asset name",
    "Quote asset name", "Fee asset name", "Base amount", "Quote amount", "Fee amount"]
  end

  def data_rows(account_name) do
    # TODO: add balance changes for assets that account have or had
    transaction_data_rows(account_name)
  end

  defp transaction_data_rows(account_name) do
    ES.invoke("account_history", account_name) |> normalized_transaction_data
  end

  def normalized_transaction_data(transactions) when is_list(transactions) do
    Enum.map(transactions, fn %{"_source" => transaction} ->
      %{"operation_type" => operation_number} = transaction

      [
        OperationName .get(operation_number),
        Description   .get(transaction, operation_number),
        TransactionID .get(transaction),
        BlockNumber   .get(transaction),
        BlockTime     .get(transaction),
        BaseAssetName .get(transaction, operation_number),
        QuoteAssetName.get(transaction, operation_number),
        FeeAssetName  .get(transaction, operation_number),
        BaseAmount    .get(transaction, operation_number),
        QuoteAmount   .get(transaction, operation_number),
        FeeAmount     .get(transaction, operation_number)
      ]
    end)
  end

  def normalized_transaction_data(_) do
    []
  end

  defp unix_time do
    :os.system_time(:millisecond)
  end
end
