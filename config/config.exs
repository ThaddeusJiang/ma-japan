# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ma,
  ecto_repos: [Ma.Repo]

config :ma, :pow,
  user: Ma.Accounts.User,
  repo: Ma.Repo

config :torch,
  otp_app: :ma,
  template_format: "eex"

# Configures the endpoint
config :ma, MaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qp0U7PT9jibSUl7gGZPJbkGvI6fWjc7QCMfGU4qdwd16S4CA9zktEjE+IVR/vyxa",
  render_errors: [view: MaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ma.PubSub,
  live_view: [signing_salt: "d8B+gddh"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
