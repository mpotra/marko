defmodule MarkoWeb.PageLiveTest do
  use MarkoWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Page A" do
    setup do
      conn = get(build_conn(), "/page_a")
      {:ok, %{conn: conn}}
    end

    test "has expected title", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      assert page_title(view) =~ "Page A"
    end

    test "has link to Page B", %{conn: conn} do
      {:ok, view, _html} = live(conn)
      assert view |> element("a[href=\"/page_b\"]") |> has_element?()
    end

    test "link patches to Page B", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      view
      |> element("a[href=\"/page_b\"]")
      |> render_click()

      assert assert_patch(view, ~p"/page_b")
    end

    test "has link to Page C Tab 1", %{conn: conn} do
      {:ok, view, _html} = live(conn)
      assert view |> element("a[href=\"/page_c/tab_1\"]") |> has_element?()
    end
  end

  describe "Page B" do
    setup do
      conn = get(build_conn(), "/page_b")
      {:ok, %{conn: conn}}
    end

    test "has expected title", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      assert page_title(view) =~ "Page B"
    end

    test "has link to Page A", %{conn: conn} do
      {:ok, view, _html} = live(conn)
      assert view |> element("a[href=\"/page_a\"]") |> has_element?()
    end

    test "link patches to Page A", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      view
      |> element("a[href=\"/page_a\"]")
      |> render_click()

      assert assert_patch(view, ~p"/page_a")
    end

    test "has link to Page C Tab 2", %{conn: conn} do
      {:ok, view, _html} = live(conn)
      assert view |> element("a[href=\"/page_c/tab_2\"]") |> has_element?()
    end
  end
end
