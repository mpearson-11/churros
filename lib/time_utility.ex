defmodule TimeUtility do
  def seconds(number) do
    number * 1000
  end
  def seconds(number, :info) do
    seconds_strings = (number / 1000)
    "#{seconds_strings} seconds"
  end
  def minutes(number) do
    (number * 60) |> seconds
  end
  def minutes(number, :info) do
    minutes_string = (number / 1000) / 60
    "#{minutes_string} minutes"
  end

  def hours(number) do
    (number * 60) |> minutes
  end
  def hours(number, :info) do
    hour_string = ((number / 1000) / 60 / 60)
    "#{hour_string} hours"
  end
end