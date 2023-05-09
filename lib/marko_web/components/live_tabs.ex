defmodule MarkoWeb.LiveTabs do
  use MarkoWeb, :live_component

  slot :tab
  attr :select_tab, :atom, required: true

  def render(assigns) do
    ~H"""
    <section id={@id}>
      <header>
        <ul class="flex flex-row text-lg">
          <%= for tab <- @tab do %>
            <%= if tab[:id] == @select_tab do %>
              <li class="flex-1 text-center bg-slate-100 font-bold
                  cursor-default rounded-lg rounded-b-none">
                <span class="inline-flex w-full mt-2 p-4 items-center justify-center">
                  <Heroicons.folder_open class="w-6 h-6 mr-2" /><%= tab[:name] %>
                </span>
              </li>
            <% else %>
              <li class="flex-1 text-center bg-slate-300 mt-3
                  rounded-lg rounded-b-none">
                <.link
                  patch={tab.path}
                  class="text-slate-50 hover:no-underline
                  inline-flex w-full p-4 items-center justify-center"
                >
                  <Heroicons.folder class="w-5 h-5 mr-2" /> <%= tab[:name] %>
                </.link>
              </li>
            <% end %>
          <% end %>
        </ul>
      </header>
      <main class="bg-slate-100 p-8 rounded-b-lg">
        <%!-- <%= render_slot(@selected_tab, @inner_block) %> --%>
        <%= for tab <- @tab, tab[:id] == @select_tab do %>
          <%= render_slot(tab, @inner_block) %>
        <% end %>
      </main>
    </section>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end
end
