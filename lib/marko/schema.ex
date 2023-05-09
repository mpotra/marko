defmodule Marko.Schema do
  @moduledoc """
  Application Schema module
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema

      @type t() :: %__MODULE__{}
      @type id() :: binary()

      @primary_key {:id, Ecto.UUID, autogenerate: false}
      @foreign_key_type Ecto.UUID
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
