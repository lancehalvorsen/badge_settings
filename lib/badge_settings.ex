defmodule BadgeSettings do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(BadgeSettings.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: BadgeSettings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BadgeSettings.Endpoint.config_change(changed, removed)
    :ok
  end
end
