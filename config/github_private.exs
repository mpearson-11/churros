use Mix.Config

config :churros,
  access_token: System.get_env("CHURROS_TOKEN"),
  team_id: System.get_env("CHURROS_TEAM_ID"),
  team_name: System.get_env("CHURROS_TEAM_NAME"),
  organisation: System.get_env("CHURROS_ORG_NAME")