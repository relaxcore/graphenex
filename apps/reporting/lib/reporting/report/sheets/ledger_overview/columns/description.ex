defmodule Reporting.Report.Sheets.LedgerOverview.Columns.Description do
  alias Reporting.Asset
  alias Reporting.BitsharesClients.RPC

  def get(transaction, 0) do
    %{"from" => sender_id,        "to" => receiver_id}        = transaction |> get_in(["operation_history", "op_object"])
    %{"amount" => raw_amount,     "asset_id" => asset_id}     = transaction |> get_in(["operation_history", "op_object", "amount_"])
    %{"amount" => raw_fee_amount, "asset_id" => fee_asset_id} = transaction |> get_in(["operation_history", "op_object", "fee"])

    [%{"id" => ^sender_id, "name" => sender_name}, %{"id" => ^receiver_id, "name" => receiver_name}] =
      RPC.invoke("get_accounts", [[sender_id, receiver_id]]) |> Poison.decode! |> Map.get("result")

    transfer_amount     = normalized_amount(raw_amount, asset_id)
    fee_amount          = normalized_amount(raw_fee_amount, fee_asset_id)
    transfer_asset_name = Asset.name(asset_id)
    fee_asset_name      = Asset.name(fee_asset_id)

    "Transfer for #{transfer_amount} #{transfer_asset_name} from #{sender_name} to #{receiver_name} " <>
    "with fee of #{fee_amount} #{fee_asset_name}"
  end

  def get(transaction, 1) do
    %{"amount" => raw_sell_amount,    "asset_id" => sell_asset_id}    = transaction |> get_in(["operation_history", "op_object", "amount_to_sell"])
    %{"amount" => raw_receive_amount, "asset_id" => receive_asset_id} = transaction |> get_in(["operation_history", "op_object", "min_to_receive"])
    %{"amount" => raw_fee_amount,     "asset_id" => fee_asset_id}     = transaction |> get_in(["operation_history", "op_object", "fee"])

    sell_amount    = normalized_amount(raw_sell_amount, sell_asset_id)
    receive_amount = normalized_amount(raw_receive_amount, receive_asset_id)
    fee_amount     = normalized_amount(raw_fee_amount, fee_asset_id)

    sell_asset_name    = Asset.name(sell_asset_id)
    receive_asset_name = Asset.name(receive_asset_id)
    fee_asset_name     = Asset.name(fee_asset_id)

    order_id = transaction |> get_in(["operation_history", "operation_result"]) |> Poison.decode! |> Enum.at(-1)

    "Create order to sell #{sell_amount} #{sell_asset_name} and get #{receive_amount} #{receive_asset_name} " <>
    "with fee of #{fee_amount} #{fee_asset_name}. Order ID: #{order_id}"
  end

  def get(transaction, 2) do
    %{"order" => order_id} = transaction |> get_in(["operation_history", "op_object"])
    %{"amount" => raw_fee_amount, "asset_id" => fee_asset_id} = transaction |> get_in(["operation_history", "op_object", "fee"])

    object_account_id  = transaction |> get_in(["account_history", "account"])
    fee_paying_account = transaction |> get_in(["operation_history", "op_object", "fee_paying_account"])
    paying_account?    = object_account_id == fee_paying_account

    fee_amount     = if paying_account?, do: normalized_amount(raw_fee_amount, fee_asset_id), else: 0
    fee_asset_name = Asset.name(fee_asset_id)

    "Cancel order #{order_id} with fee of #{fee_amount} #{fee_asset_name}"
  end

  def get(_, _), do: ""

  def normalized_amount(raw_amount, asset_id) do
    precision = Asset.precision(asset_id)
    amount    = raw_amount / :math.pow(10, precision)

    :erlang.float_to_binary(amount, [:compact, {:decimals, precision}]) # escape E notation
  end
end
