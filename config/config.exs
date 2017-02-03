# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :one_harmony,
  ecto_repos: [OneHarmony.Repo]

# Configures the endpoint
config :one_harmony, OneHarmony.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BWVefL2qpw0uBc0B6CfaWBHVG3KlckZmcnkEWWQmZ2yBEglgIKqYadcT+PqnkDnU",
  render_errors: [view: OneHarmony.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OneHarmony.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
