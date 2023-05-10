defmodule MarkoWeb.PageLive do
  @moduledoc """
  Page A LiveView module
  """

  use MarkoWeb, :live_view

  alias MarkoWeb.PageUtils

  @impl true
  def render(assigns) do
    ~H"""
    <section id="page_live" phx-hook="PageView" data-page={@page}>
      <%= case @page do %>
        <% :page_a -> %>
          <p>
            Go to&nbsp;
            <.link patch={~p"/page_b"} class="inline-flex items-baseline">
              <Heroicons.document class="w-3 h-3 mr-2" /> Page B
            </.link>
          </p>
          <p>
            Go to&nbsp;
            <.link navigate={~p"/page_c/tab_1"} class="inline-flex items-baseline">
              <Heroicons.folder class="w-3 h-3 mr-2" /> Page C
              &nbsp; <Heroicons.chevron_right class="w-3 h-3 mr-2" />
              <Heroicons.document class="w-3 h-3 mr-2" /> Tab 1
            </.link>
          </p>
        <% :page_b -> %>
          <p>
            Go to&nbsp;
            <.link patch={~p"/page_a"} class="inline-flex items-baseline">
              <Heroicons.document class="w-3 h-3 mr-2" /> Page A
            </.link>
          </p>
          <p>
            Go to&nbsp;
            <.link navigate={~p"/page_c/tab_2"} class="inline-flex items-baseline">
              <Heroicons.folder class="w-3 h-3 mr-2" /> Page C
              &nbsp; <Heroicons.chevron_right class="w-3 h-3 mr-2" />
              <Heroicons.document class="w-3 h-3 mr-2" /> Tab 2
            </.link>
          </p>
      <% end %>
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
          :page_a ->
            socket
            |> assign(:page_title, "Page A")
            |> assign(:page, :page_a)

          :page_b ->
            socket
            |> assign(:page_title, "Page B")
            |> assign(:page, :page_b)
        end
        |> PageUtils.assign_new_pageview(__MODULE__)
      else
        socket
      end

    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    PageUtils.end_pageview(socket)
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
