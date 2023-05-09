defmodule MarkoWeb.PageLive do
  @moduledoc """
  Page A LiveView module
  """

  use MarkoWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <section>
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
            <.link patch={~p"/page_c/tab_1"} class="inline-flex items-baseline">
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
            <.link patch={~p"/page_c/tab_2"} class="inline-flex items-baseline">
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
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    socket =
      case socket.assigns.live_action do
        :page_a ->
          socket
          |> assign(:page_title, "Page A")
          |> assign(:page, :page_a)

        :page_b ->
          socket
          |> assign(:page_title, "Page B")
          |> assign(:page, :page_b)
      end

    {:noreply, socket}
  end
end
