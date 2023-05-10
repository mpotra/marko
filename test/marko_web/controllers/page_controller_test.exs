defmodule MarkoWeb.PageControllerTest do
  use MarkoWeb.ConnCase
  alias Plug.Conn

  setup do
    conn = Conn.put_req_header(build_conn(), "user-agent", "test")
    {:ok, %{conn: conn}}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Select a page"
  end
end
