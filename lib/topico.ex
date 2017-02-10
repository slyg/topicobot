defmodule Topico do
  use Application, Slack

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    slack_token = Application.get_env(:slack, :api_token)

    children = [
      worker(Slack.Bot, [Topico.Bot, [], slack_token])
    ]

    opts = [strategy: :one_for_one, name: Topico.Supervisor]

    Supervisor.start_link(children, opts)
  end

end
