defmodule MarkoWeb.Router do
  use MarkoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MarkoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MarkoWeb.PlugSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MarkoWeb do
    pipe_through :browser

    get "/", PageController, :home

    live_session :pages do
      live "/page_a", PageLive, :page_a
      live "/page_b", PageLive, :page_b
      live "/page_c", TabbedPageLive, :index
      live "/page_c/tab_1", TabbedPageLive, :tab_1
      live "/page_c/tab_2", TabbedPageLive, :tab_2
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MarkoWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:marko, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MarkoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
