defmodule Bot do
  use Slack

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "presence_change", presence: "active"}, slack, state) do

    IO.inspect message
    send_message("Hello !", Slack.Lookups.lookup_direct_message_id(message.user, slack), slack)

    {:ok, state}
  end
  def handle_event(message = %{type: "message"}, slack, state) do
    case message.text do
       "Hi" ->
         send_message("Hope you're doing well :grinning:", message.channel, slack)
       "Bye" ->
         send_message("Bye bye !", message.channel, slack)
      _ ->
        {:ok, state}
    end

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

end
