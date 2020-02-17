defmodule Reporting.Report.Columns.BlockTime do
  def get(transaction) do
    transaction |> get_in(["block_data", "block_time"])
  end
end
