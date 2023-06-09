defmodule Marko.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    config = Marko.Config.load!()

    children = [
      # Start the Telemetry supervisor
      MarkoWeb.Telemetry,
      # Start the Ecto repository
      Marko.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Marko.PubSub},
      # Start Finch
      {Finch, name: Marko.Finch},
      # Start the Endpoint (http/https)
      {MarkoWeb.Endpoint, config.endpoint}
      # Start a worker by calling: Marko.Worker.start_link(arg)
      # {Marko.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Marko.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarkoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
