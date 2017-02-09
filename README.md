# Bot

Sample Slack bot

## Installation

Meh, later...

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bot](https://hexdocs.pm/bot).

### Interact

#### Config

In `config/config.exs`:

```exs
use Mix.Config

...
config :slack, api_token: <API_TOKEN>
...
```

#### Compile

```
$ mix run --no-halt
```

#### Start bot via repl

```
# start iex

$ iex -S mix
```

```
# starts bot process

iex> {:ok, bot} = Slack.Bot.start_link(Bot, [], Application.get_env(:slack, :api_token))
```
