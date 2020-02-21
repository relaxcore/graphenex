defmodule Reporting.Report do
  require Elixlsx

  alias Elixlsx.Workbook
  alias Reporting.Report.Sheets.LedgerOverview

  def generate(_, account_name) when not is_binary(account_name), do: {:error, "Invalid account name format!"}
  def generate(:csv, _),                                          do: {:error, "Not implemented!"}

  def generate(:xlsx, account_name) do
    unix_time = :os.system_time(:millisecond)
    file_path = "./apps/reporting/generated_reports/#{unix_time}_#{account_name}.xlsx"

    %Workbook{sheets: sheets(account_name)} |> Elixlsx.write_to(file_path)
  end

  def generate(_, _), do: {:error, "Undefined file format!"}

  defp sheets(account_name) do
    # use dynamic sheet list based on account transaction operation_ids; only ledger overview for now
    [LedgerOverview.sheet(account_name)]
  end
end
