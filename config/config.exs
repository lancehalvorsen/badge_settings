# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :badge_settings, BadgeSettings.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R02jL0Vi+tFH7YOecTua/oc0b2dETOQT8/Sg9dD56EDKqmd8jRAdqa0CyZ7tOFIt",
  render_errors: [view: BadgeSettings.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BadgeSettings.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :badge_settings, ecto_repos: []

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :badge_settings, :nerves_settings, %{
  settings_file: "nerves_settings.txt",
  device_name: "fill_me_in"
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
