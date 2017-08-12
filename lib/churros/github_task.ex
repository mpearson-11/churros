defmodule Churros.GithubTask do
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

  def init(_) do
    # Task starter
    start_after = start_work_time()
    Process.send_after(self(), :work, start_after)
    Process.send_after(self(), :work_timer, (start_after - 1))
    {:ok, work_time()}
  end

  def work_time do
    time = Application.get_env(:churros, :work_timer) || 3
    time |> minutes
  end

  def start_work_time do
    time = Application.get_env(:churros, :start_work_timer) || 2
    time |> minutes
  end

  defp work_task() do
    Churros.GithubController.repository_projects()
  end

  def handle_info(:work_timer, load_time) do
    # Return log for how long left for task to refresh!!!
    Logger.info "Loading in: #{seconds(load_time, :converted)}"

    Process.send_after(self(), :work_timer, 1000)
    {:noreply, load_time - 1000}
  end

  def handle_info(:work, _) do
    Logger.info "Github Task: repository_projects, every: #{minutes(work_time(), :converted)}"

    work_task() # Private function work task
    Process.send_after(self(), :work, work_time())
    {:noreply, work_time()}
  end
end