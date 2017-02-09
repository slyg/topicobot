defmodule Bot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    case message.text do
       "Hi" ->
         send_message("Hello to you too !!!", message.channel, slack)
       "Bye" ->
         send_message("Bye bye !", message.channel, slack)
      _ ->
        {:ok, state}
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

end
