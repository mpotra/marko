defmodule Marko.PageView do
  @moduledoc """
  Model schema for page view
  """

  use Marko.Schema
  alias Ecto.Changeset
  alias Marko.Session

  @required_fields [:session_id, :view, :page]
  @optional_fields [:info, :engagement_time, :updated_at]

  schema "pageviews" do
    belongs_to :session, Session

    field :view, :string
    field :page, :string
    field :info, :string
    field :engagement_time, :integer

    field :state, :string, default: "init", virtual: true
    field :paused_at, :utc_datetime_usec, virtual: true
    field :finished, :boolean, default: false, virtual: true

    timestamps()
  end

  @spec create(params :: map()) :: Ecto.Changeset.t()
  def create(params \\ %{})

  def create(%__MODULE__{} = params) do
    params
    |> Map.take(@required_fields ++ @optional_fields)
    |> create()
  end

  def create(%{view: view} = params) when is_atom(view) do
    params
    |> Map.replace(:view, Atom.to_string(view))
    |> create()
  end

  def create(%{page: page} = params) when is_atom(page) do
    params
    |> Map.replace(:page, Atom.to_string(page))
    |> create()
  end

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

  @doc """
  Updates engagement_time on a running PageView,
  by adding the difference between current time and last update time, to engagement_time
  """
  @spec update_engagement_time(pageview :: t()) :: t()
  def update_engagement_time(
        %__MODULE__{engagement_time: engagement_time, paused_at: nil, updated_at: updated_at} =
          pageview
      ) do
    %{
      pageview
      | engagement_time: engagement_time + Timex.diff(DateTime.utc_now(), updated_at, :second),
        updated_at: DateTime.utc_now()
    }
  end

  def update_engagement_time(%__MODULE__{} = pageview) do
    pageview
  end

  @doc """
  Finishes a PageView.
  Updates engagement time.
  Unpauses PageView.
  """
  @spec finish(pageview :: t()) :: t()
  def finish(%__MODULE__{} = pageview) do
    pageview
    |> update_engagement_time()
    |> Map.put(:paused_at, nil)
  end

  def finish(pageview) do
    pageview
  end

  @doc """
  Pause a PageView. Updates `engagement_time`
  If already paused, does nothing
  """
  @spec pause(pageview :: t()) :: t()
  def pause(%__MODULE__{paused_at: nil} = pageview) do
    pageview
    |> update_engagement_time()
    |> Map.put(:paused_at, DateTime.utc_now())
  end

  def pause(pageview) do
    pageview
  end

  @doc """
  Mark a PageView as resumed, if paused.
  If not paused, does nothing.
  """
  @spec resume(pageview :: t()) :: t()
  def resume(%__MODULE__{paused_at: nil} = pageview) do
    pageview
  end

  def resume(pageview) do
    %{
      pageview
      | paused_at: nil,
        updated_at: DateTime.utc_now()
    }
  end
end
