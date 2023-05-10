defmodule Marko.Sessions do
  @moduledoc """
  Handle browser sessions
  """
  require Ecto.Query
  alias Marko.Repo
  alias Marko.Session
  alias Ecto.Query

  @doc """
  Create a new Session record
  """
  @spec create!(user_agent :: binary()) :: Session.t()
  def create!(user_agent) do
    user_agent
    |> create()
    |> case do
      {:ok, session} -> session
      {:error, changeset} -> raise changeset
    end
  end

  @doc """
  Create a new Session record
  """
  @spec create(user_agent :: binary()) :: {:ok, Session.t()} | {:error, term()}
  def create(user_agent) do
    %{user_agent: user_agent}
    |> Session.create()
    |> Repo.insert(returning: true)
  end

  @doc """
  Retrieve a Session record based on id
  """
  @spec get(sid :: binary()) :: nil | Session.t()
  def get(sid) do
    build_query()
    |> Query.where([s], s.id == ^sid)
    |> Repo.one()
  end

  @spec build_query() :: Ecto.Query.t()
  defp build_query() do
    Query.from(s in Session)
  end
end
