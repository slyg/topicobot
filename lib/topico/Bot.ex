defmodule Bot do
  use Slack

  @message_types [
    {~r/(hi|hey|hello|salut)/, :hi},
    {~r/(yes|yep)/, :yes},
    {~r/(no|nope)/, :no},
    {~r/bye/, :bye}
  ]

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

      case reply(message.text) do

        {:ok, response, {:yes, _}} ->
          send_message(response, message.channel, slack)

        {:ok, response, {:no, _}} ->
          send_message(response, message.channel, slack)

        {:ok, response, _} ->
          attachments = [
            %{
              title: "Are you WFH today ?",
              callback_id: "123",
              attachment_type: "default",
              actions: [
                %{name: "yes", text: "Yes", value: "yes", type: "button"},
                %{name: "no", text: "No", value: "no", type: "button"}
              ]
            }
          ] |> JSX.encode!

          Slack.Web.Chat.post_message(message.channel, response, %{ attachments: attachments })

        _ ->
          {:ok, state}
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

  defp do_reply(msg = {:hi, _}),  do: {:ok, "I hope you're doing well :grinning:.", msg}
  defp do_reply(msg = {:no, _}),  do: {:ok, ":office: I understand you're in the office today, have a good day !", msg}
  defp do_reply(msg = {:yes, _}), do: {:ok, ":house: I understand you're working from home today, enjoy the flow !", msg}
  defp do_reply(msg = {:bye, _}), do: {:ok, "Bye bye !", msg}
  defp do_reply(msg),             do: {:ko, nil, msg}

end
