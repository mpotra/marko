defmodule MarkoWeb.PlugSession do
  @moduledoc """
  Plug that registers a Session in the database
  using Marko.Sessions, with the given User-Agent
  """
  alias Plug.Conn
  alias Marko.Sessions

  def init(options) do
    options
  end

  def call(%Plug.Conn{} = conn, _opts) do
    conn
    |> Conn.get_session(:session_id)
    |> case do
      nil -> register_session(conn)
      _session_id -> conn
    end
  end

  defp register_session(conn) do
    session_id =
      conn
      |> Conn.get_req_header("user-agent")
      |> case do
        [ua] when is_binary(ua) -> ua
        _ -> ""
      end
      |> Sessions.create!()
      |> Map.get(:id)

    Conn.put_session(conn, :session_id, session_id)
  end
end
