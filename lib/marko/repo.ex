defmodule Marko.Repo do
  @moduledoc """
  Application Repo module
  """

  use Ecto.Repo,
    otp_app: :marko,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Defines the Ecto.Repo.init/2 callback that allows altering the Repo configuration.

  It loads the environment variables via Vapor
  and appends these to the compiled configs.
  """
  def init(_type, config) do
    repo_config =
      Marko.Config.load!()
      |> Map.get(:repo)

    {:ok, Keyword.merge(config, repo_config)}
  end
end
