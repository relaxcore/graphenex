defmodule BitsharesReporting.BitsharesClient do
  def invoke(method, params) do
    conn = Socket.Web.connect!("ws-dex.bitspark.io")
    Socket.Web.send!(conn, payload(method, params))

    {:text, response} = Socket.Web.recv!(conn)
    response
  end

  defp payload(method, params) do
    msg = %{id: 1, method: "call", params: [0, method, params]} |> Poison.encode!()
    {:text, msg}
  end
end
