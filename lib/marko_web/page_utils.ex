defmodule MarkoWeb.PageUtils do
  @moduledoc """
  Module that provides helper functions for
  handline PageView records in a LiveView
  """
  use MarkoWeb, :live_util

  alias Marko.{PageView, PageViews}
  alias Phoenix.LiveView.Socket

  @spec get_engagement_time(socket :: Socket.t()) :: pos_integer()
  def get_engagement_time(%{assigns: %{pageview: %PageView{engagement_time: engagement_time}}}) do
    engagement_time
  end

  def get_engagement_time(_) do
    0
  end

  @spec end_pageview(socket :: Socket.t()) :: Socket.t()
  def end_pageview(
        %{
          assigns: %{
            pageview: %PageView{finished: false} = pageview
          }
        } = socket
      ) do
    pageview =
      pageview
      |> PageView.pause()
      |> PageViews.register!()
      |> Map.put(:finished, true)

    socket
    |> assign(:pageview, %{pageview | paused_at: DateTime.utc_now()})
  end

  def end_pageview(socket) do
    socket
  end

  @spec assign_new_pageview(socket :: Socket.t(), module :: module()) :: Socket.t()
  def assign_new_pageview(%{assigns: %{session_id: session_id, page: page}} = socket, module)
      when not is_nil(session_id) do
    pageview = %PageView{
      session_id: session_id,
      view: module,
      page: page,
      engagement_time: 0,
      paused_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    }

    socket |> assign(:pageview, pageview)
  end

  def assign_new_pageview(socket, _module) do
    socket
  end

  @spec pause_pageview(socket :: Socket.t()) :: Socket.t()
  def pause_pageview(
        %{
          assigns: %{
            pageview: %PageView{} = pageview
          }
        } = socket
      ) do
    socket |> assign(:pageview, PageView.pause(pageview))
  end

  def pause_pageview(socket) do
    socket
  end

  @spec resume_pageview(socket :: Socket.t()) :: Socket.t()
  def resume_pageview(
        %{
          assigns: %{
            pageview: %PageView{} = pageview
          }
        } = socket
      ) do
    socket |> assign(:pageview, PageView.resume(pageview))
  end

  def resume_pageview(socket) do
    socket
  end
end
