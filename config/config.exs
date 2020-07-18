# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hello2,
  ecto_repos: [Hello2.Repo]

# Configures the endpoint
config :hello2, Hello2Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LoMj6tisHaAaNx2B+H7sdJ4FPzaxIpOU3krn5lqRTHi+ev8kz0wHYER1aS0LI2aX",
  render_errors: [view: Hello2Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Hello2.PubSub,
  live_view: [signing_salt: "x9zkc4q/"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
