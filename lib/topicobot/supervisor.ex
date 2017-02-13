defmodule Topicobot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    slack_token = Application.get_env(:slack, :api_token)

    children = [
      worker(Slack.Bot, [Topicobot.Handler, [], slack_token])
    ]

    supervise(children, [strategy: :one_for_one, name: Topicobot.Supervisor])
  end
end
