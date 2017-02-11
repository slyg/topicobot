defmodule Topicobot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:slack, :api_token)

    children = [
      worker(Slack.Bot, [Topicobot.Handler, [], slack_token])
    ]

    opts = [strategy: :one_for_one, name: Topicobot.Supervisor]

    Supervisor.start_link(children, opts)
  end

end
