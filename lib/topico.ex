defmodule Topico do
  use Slack

  def start(_type, _args) do

    slack_token = Application.get_env(:slack, :api_token)
    opts = %{strategy: :one_for_one, name: Topico.Supervisor}

    Slack.Bot.start_link(Bot, [], slack_token, opts)
  end

end
