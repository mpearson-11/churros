use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.

config :churros,
  access_token: "TEST_ACCESS_TOKEN",
  team_id: "TEST_TEAM_ID",
  team_name: "TEST_TEAM_NAME",
  organisation: "TEST_ORGANISATION",
  watched_repo: "TEST_WATCHED_REPOS"

config :churros, Churros.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
