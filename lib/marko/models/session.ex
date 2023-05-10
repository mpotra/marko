defmodule Marko.Session do
  @moduledoc """
  Model schema for Session
  """

  use Marko.Schema
  alias Ecto.Changeset

  @required_fields [:user_agent]
  @optional_fields []

  schema "sessions" do
    field :user_agent, :string
    timestamps()
  end

  @spec create(map()) :: Ecto.Changeset.t()
  def create(params \\ %{})

  def create(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(changeset, attrs) do
    changeset
    |> Changeset.cast(attrs, @required_fields ++ @optional_fields)
    |> Changeset.validate_required(@required_fields)
  end
end
