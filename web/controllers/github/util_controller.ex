defmodule Churros.Github.UtilController do
  use Churros.Web, :controller

  def organisation_teams(org) do
    "query {
      organization(login: \"#{org}\") {
        name
        teams(first: 100) {
          nodes {
            name
          }
        }
      }
    }"
  end

  def organisation_members(org) do
    "query { 
      organization(login: \"#{org}\") {
        members(first: 100) {
          nodes {
            name
          }
        }
      }
    }"
  end
end