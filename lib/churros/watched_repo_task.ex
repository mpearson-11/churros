defmodule Churros.WatchedRepoTask do
  @moduledoc """
  GithubTask calls repository_projects function for GithubController, every 3 minutes
  and the console will log out how long before the function runs again.
  """

  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, 0)
  end

  defp enabled_projects do
    ["2"]
  end

  def init(_) do
    # Task starter
    start_after = start_work_time()
    Process.send_after(self(), :work, start_after)
    {:ok, work_time()}
  end

  def start_work_time do
    1 |> TimeUtility.minutes
  end

  def work_time do
    45 |> TimeUtility.seconds
  end

  defp work_tasks do
    watched_repo = Application.get_env(:churros, :watched_repo)
    Enum.each(enabled_projects, fn(project) ->
      Churros.GithubController.watched_project(watched_repo, project)
    end)
  end

  def handle_info(:work, _) do
    Logger.info "\nWatched Repo Task"
    work_tasks() # Private function work task
    Process.send_after(self(), :work, work_time())
    {:noreply, work_time()}
  end
end