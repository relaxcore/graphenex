defmodule Reporting.BitsharesClients.ES do
  alias Reporting.BitsharesClients.RPC

  @headers [{"Content-Type", "application/json"}]
  @url "https://BitShares:Infrastructure@eu.elasticsearch.bitshares.ws:443/bitshares-*/data/_search"
  @options [timeout: 20_000_000, recv_timeout: 20_000_000]

  def invoke("account_history", account_name) do
    account_id = get_account_id(account_name)

    unless is_nil(account_id) do
      {status, response} = HTTPoison.request(:get, @url, account_history_payload(account_id), @headers, @options)
      with :ok <- status, 200 <- response.status_code, do: response.body |> Poison.decode! |> get_in(["hits", "hits"])
    end
  rescue
    _ -> nil
  end

  def invoke(_), do: nil

  defp account_history_payload(account_id) do
    # TODO: ES node throw 500 if object size > 10000. Fix with recursion or try other node
    %{
      "size" => 10_000,
      "sort" => [%{"operation_id_num" => %{"order" => "asc", "unmapped_type" => "boolean"}}],
      "query" => %{
        "bool" => %{
          "must" => [
            %{"match" => %{"account_history.account" => %{"query" => account_id}}}
          ]
        }
      }
    } |> Poison.encode!
  end

  defp get_account_id(account_name) do
   response = RPC.invoke("get_accounts", [[account_name]]) |> Poison.decode! |> Map.get("result")
   if is_list(response), do: response |> hd |> Map.get("id")
  end
end
