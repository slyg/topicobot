defmodule Topicobot do
  use Application

  def start(_type, _args) do
    Topicobot.Supervisor.start_link
  end
end
