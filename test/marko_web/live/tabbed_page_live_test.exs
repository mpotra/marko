defmodule MarkoWeb.TabbedPageLiveTest do
  use MarkoWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Page C" do
    setup do
      conn = get(build_conn(), "/page_c")
      {:ok, %{conn: conn}}
    end

    test "redirects to a tab", %{conn: conn} do
      assert redirected_to(conn) =~ "/page_c/tab_"
    end
  end

  describe "Page C - Tab 1" do
    setup do
      conn = get(build_conn(), "/page_c/tab_1")
      {:ok, %{conn: conn}}
    end

    test "has expected title", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      assert page_title(view) =~ "Tab 1 - Page C"
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

    test "has tab link to Tab 2", %{conn: conn} do
      {:ok, view, _html} = live(conn)
      assert view |> element("a[href=\"/page_c/tab_2\"]") |> has_element?()
    end

    test "link patches to Tab 2", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      view
      |> element("a[href=\"/page_c/tab_2\"]")
      |> render_click()

      assert assert_patch(view, ~p"/page_c/tab_2")
    end
  end

  describe "Page C - Tab 2" do
    setup do
      conn = get(build_conn(), "/page_c/tab_2")
      {:ok, %{conn: conn}}
    end

    test "has expected title", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      assert page_title(view) =~ "Tab 2 - Page C"
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

    test "has tab link to Tab 1", %{conn: conn} do
      {:ok, view, _html} = live(conn)
      assert view |> element("a[href=\"/page_c/tab_1\"]") |> has_element?()
    end

    test "link patches to Tab 1", %{conn: conn} do
      {:ok, view, _html} = live(conn)

      view
      |> element("a[href=\"/page_c/tab_1\"]")
      |> render_click()

      assert assert_patch(view, ~p"/page_c/tab_1")
    end
  end
end
