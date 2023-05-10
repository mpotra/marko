defmodule MarkoWeb.TabbedPageLive do
  @moduledoc """
  Page C LiveView module
  """

  use MarkoWeb, :live_view
  alias MarkoWeb.LiveTabs
  alias MarkoWeb.PageUtils

  @impl true
  def render(assigns) do
    ~H"""
    <section id="tabbed_page" phx-hook="PageView" data-page={@page}>
      <.live_component module={LiveTabs} id="tabs" select_tab={@page}>
        <:tab id={:tab_1} path={~p"/page_c/tab_1"} name="Tab 1">
          <p>
            Go to&nbsp;
            <.link patch={~p"/page_b"} class="inline-flex items-baseline">
              <Heroicons.document class="w-3 h-3 mr-2" /> Page B
            </.link>
          </p>
        </:tab>
        <:tab id={:tab_2} path={~p"/page_c/tab_2"} name="Tab 2">
          <p>
            Go to&nbsp;
            <.link patch={~p"/page_a"} class="inline-flex items-baseline">
              <Heroicons.document class="w-3 h-3 mr-2" /> Page A
            </.link>
          </p>
        </:tab>
      </.live_component>
    </section>
    """
  end

  @impl true
  def mount(_params, %{"session_id" => session_id}, socket) do
    {:ok,
     socket
     |> assign(:session_id, session_id)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    next_page = socket.assigns.live_action

    socket =
      if Map.get(socket.assigns, :page) != next_page do
        socket = PageUtils.end_pageview(socket)

        next_page
        |> case do
          :index ->
            random_tab = Enum.random(["tab_1", "tab_2"])
            random_tab_path = "/page_c/#{random_tab}"
            push_navigate(socket, to: random_tab_path, replace: true)

          :tab_1 ->
            socket
            |> assign(:page_title, "Tab 1 - Page C")
            |> assign(:page, :tab_1)
            |> PageUtils.assign_new_pageview(__MODULE__)

          :tab_2 ->
            socket
            |> assign(:page_title, "Tab 2 - Page C")
            |> assign(:page, :tab_2)
            |> PageUtils.assign_new_pageview(__MODULE__)
        end
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("page-resume", %{"page" => _page} = _params, socket) do
    socket = PageUtils.resume_pageview(socket)
    {:reply, %{engagementTime: PageUtils.get_engagement_time(socket)}, socket}
  end

  def handle_event("page-pause", %{"page" => _page} = _params, socket) do
    socket = PageUtils.pause_pageview(socket)
    {:reply, %{engagementTime: PageUtils.get_engagement_time(socket)}, socket}
  end

  def handle_event("page-unload", %{"page" => _page} = _params, socket) do
    socket = PageUtils.end_pageview(socket)
    {:reply, %{engagementTime: PageUtils.get_engagement_time(socket)}, socket}
  end
end
