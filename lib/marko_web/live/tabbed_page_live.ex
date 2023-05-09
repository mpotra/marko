defmodule MarkoWeb.TabbedPageLive do
  @moduledoc """
  Page C LiveView module
  """

  use MarkoWeb, :live_view
  alias MarkoWeb.LiveTabs

  @impl true
  def render(assigns) do
    ~H"""
    <section>
      <.live_component module={LiveTabs} id="tabs" select_tab={@tab}>
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
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      case socket.assigns.live_action do
        :index ->
          random_tab = Enum.random(["tab_1", "tab_2"])
          random_tab_path = "/page_c/#{random_tab}"
          push_navigate(socket, to: random_tab_path, replace: true)

        :tab_1 ->
          socket
          |> assign(:page_title, "Tab 1 - Page C")
          |> assign(:tab, :tab_1)

        :tab_2 ->
          socket
          |> assign(:page_title, "Tab 2 - Page C")
          |> assign(:tab, :tab_2)
      end

    {:noreply, socket}
  end
end
