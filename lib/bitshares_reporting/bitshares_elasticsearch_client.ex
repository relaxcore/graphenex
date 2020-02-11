defmodule BitsharesReporting.ElasticsearchClient do
  alias BitsharesReporting.BitsharesRpcClient

  @headers [{"Content-Type", "application/json"}]
  @url "https://BitShares:Infrastructure@eu.elasticsearch.bitshares.ws:443/bitshares-*/data/_search"
  @options [timeout: 20_000_000, recv_timeout: 20_000_000]

  def invoke("account_history", account_name) do
    %{"id" => account_id} = get_account_object(account_name)
    {status, response}    = HTTPoison.request(:get, @url, account_history_payload(account_id), @headers, @options)

    with :ok <- status, 200 <- response.status_code, do: response.body |> Poison.decode! |> get_in(["hits", "hits"])
  end

  def invoke(_), do: nil

  defp account_history_payload(account_id) do
    %{
      "size" => 10000,
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

  defp get_account_object(account_name) do
   [account_object] = BitsharesRpcClient.invoke("get_accounts", [[account_name]]) |> Poison.decode! |> Map.get("result")
   account_object
  end
end
