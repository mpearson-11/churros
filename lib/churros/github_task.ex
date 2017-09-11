defmodule Churros.GithubTask do
  @moduledoc """
    GithubTask for refreshing issues and projects board
  """

  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, 0)
  end

  def init(_) do
    # Task starter
    start_after = initialise_tasks_time() # wait till tasks are started

    Process.send_after(self(), :github_issues_work, start_after)
    Process.send_after(self(), :github_projects_work, (start_after - 1))
    
    # Send interval to state
    {:ok, projects_task_interval()}
  end

  defp projects_task_interval do
    24 * 60 |> TimeUtility.minutes
  end

  defp issues_task_interval do
    5 |> TimeUtility.minutes
  end

  defp initialise_tasks_time do
    1 |> TimeUtility.minutes
  end

  def handle_info(:github_issues_work, state) do
    Logger.info "Github Issues Task"
    Churros.Endpoint.broadcast!("github:lobby", "refresh_issues", %{})
    Process.send_after(self(), :github_issues_work, issues_task_interval())
    {:noreply, state}
  end

  def handle_info(:github_projects_work, state) do
    Logger.info "Github Projects Task"
    Churros.GithubController.repository_projects() #Load Repository Projects
    Process.send_after(self(), :github_projects_work, projects_task_interval())
    {:noreply, state}
  end
end