defmodule Churros.GithubBoardTasks do
  @moduledoc """
  GithubTask calls repository_projects function for GithubController, every 3 minutes
  and the console will log out how long before the function runs again.
  """

  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, 0)
  end

  defp seconds(number, :converted) do
    "#{(number / 1000)} seconds"
  end

  defp minutes(number) do
    number * 60 * 1000
  end
  defp minutes(number, :converted) do
    "#{(number / 1000) / 60} minutes"
  end
  defp enabled_boards do
    ["14", "21"]
  end

  def init(_) do
    # Task starter
    start_after = start_work_time()
    Process.send_after(self(), :work, start_after)
    {:ok, work_time()}
  end

  def start_work_time do
    time = Application.get_env(:churros, :start_work_timer) || 1
    time |> minutes
  end

  def work_time do
    time = Application.get_env(:churros, :work_timer) || 2
    time |> minutes
  end

  defp work_tasks do
    Enum.each(enabled_boards, fn(board) ->
      Churros.GithubController.repository_project(board)
    end)
  end

  def handle_info(:work, _) do
    Logger.info "\nGithub Task: repository_project, every: #{minutes(work_time(), :converted)}"

    work_tasks() # Private function work task
    Process.send_after(self(), :work, work_time())
    {:noreply, work_time()}
  end
end