defmodule Ma.Repo do
  use Ecto.Repo,
    otp_app: :ma,
    adapter: Ecto.Adapters.Postgres
end
