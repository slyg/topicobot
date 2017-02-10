defmodule Bot do
  use Slack

  @message_types [{~r/(hi|hey|yup|hello|salut)/, :hi}, {~r/bye/, :bye}]

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.name}"
    {:ok, state}
  end

  def handle_event(message = %{type: "presence_change", presence: "active"}, slack, state) do
    user_dm_channel_id = Slack.Lookups.lookup_direct_message_id(message.user, slack)
    send_message("Hello :)", user_dm_channel_id, slack)
    
    {:ok, state}
  end
  def handle_event(message = %{type: "message"}, slack, state) do
    if is_direct_message?(message, slack) do
      reply = reply(message.text)
      case reply do
        {:ok, response} -> send_message(response, message.channel, slack)
        _ -> {:ok, state}
      end
    end

    {:ok, state}
  end
  def handle_event(_message, _slack, state), do: {:ok, state}

  defp is_direct_message?(%{channel: channel}, slack), do: Map.has_key? slack.ims, channel

  defp reply(msg) do
    msg |> parse |> do_reply
  end

  defp parse(msg) do
    {_, type} = Enum.find(@message_types, {nil, :unknown}, fn {reg, _type} ->
       String.match?(msg, reg)
     end)
    {type, msg}
  end

  defp do_reply({:hi, _msg}), do: {:ok, "Hi, I hope you're doing well :grinning:"}
  defp do_reply({:bye, _msg}), do: {:ok, "Bye bye !"}
  defp do_reply(_), do: {:ko, nil}

end
