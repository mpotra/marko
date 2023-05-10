defmodule Marko.PageViews do
  @moduledoc """
  Module that handles PageView database operations
  """

  alias Marko.Repo
  alias Marko.PageView

  @spec register!(params :: map() | PageView.t()) :: PageView.t()
  def register!(%{} = pageview) do
    pageview
    |> register()
    |> case do
      {:ok, pageview} ->
        pageview

      {:error, changeset} ->
        raise """
        Failed to register PageView:
        #{inspect(changeset)}
        """
    end
  end

  @spec register(params :: map() | PageView.t()) ::
          {:ok, PageView.t()} | {:error, Ecto.Changeset.t()}
  def register(%{} = pageview) do
    pageview
    |> PageView.create()
    |> Repo.insert(returning: true)
  end
end
