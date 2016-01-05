# ExqUi

[![Travis Build Status](https://img.shields.io/travis/akira/exq_ui.svg)](https://travis-ci.org/akira/exq_ui)
[![Coveralls Coverage](https://img.shields.io/coveralls/akira/exq_ui.svg)](https://coveralls.io/github/akira/exq_ui)
[![Hex.pm Version](https://img.shields.io/hexpm/v/exq_ui.svg)](https://hex.pm/packages/exq_ui)

ExqUI provides a UI dashboard for [Exq](https://github.com/akira/exq), a job processing library compatible with Resque / Sidekiq for the [Elixir](http://elixir-lang.org) language.
ExqUI allow you to see various job processing stats, as well as details on failed, retried, scheduled jobs, etc.


## Getting Started:

See [Exq](https://github.com/akira/exq) for using the Exq library.
This assumes you have an instance of [Redis](http://redis.io/).

### Installation:
Add exq_ui to your mix.exs deps (replace version with the latest hex.pm package version):

```elixir
  defp deps do
    [
      # ... other deps
      {:exq_ui, "~> 0.6.0"}
    ]
  end
```

Then run ```mix deps.get```.

### Configuration:

By default, Exq will use configuration from your config.exs file.  You can use this
to configure your Redis host, port, password, as well as namespace (which helps isolate the data in Redis).

```elixir
config :exq,
  host: "127.0.0.1",
  port: 6379,
  password: "optional_redis_auth",
  namespace: "exq",
  concurrency: :infinite,
  queues: ["default"],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 25
```

There are also a few configuration options for the UI:
```elixir
config :exq_ui,
  webport: 4040,
  web_namespace: ""
```

The webport configures which port to start the UI on, and the web_namespace configures what to use as the application root
(both when using `mix exq.ui`).

By default the empty namespace is used, so you can access the UI via:  `http://localhost:4040/`.

When setting a different web_namespace, for example `exq_ui`, you can access the UI via: `http://localhost:4040/exq_ui`.

## Web UI:

This is a screenshot of the UI Dashboard provided by Exq UI:
![Screenshot](http://i.imgur.com/m57gRPY.png)

To start the web UI:
```
> mix exq.ui
```

## Using with Plug

To use this with Plug

```elixir
...
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
    # note that you need to remove the :protect_from_forgery plug and place it inside its own pipeline
    plug ExqUi.RouterPlug, namespace: "exq"
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end

...
  scope "/", MyApp do
    pipe_through :browser

    forward "/exq", ExqUi.RouterPlug.Router, :index
  end
```


## Contributions

Contributions are welcome. Tests are encouraged.

By default, a static distribution of the UI is used.
To run the UI and automatically build the JS distribution on changes, run:

```
> cd priv/ember
> npm install
> bower install
> ./node_modules/ember-cli/bin/ember server
```

To run tests / ensure your changes have not caused any regressions:

```
mix test --no-start
```

## Contributors:

Justin McNally (j-mcnally) (structtv)

Nick Sanders (nicksanders)

Nick Gal (nickgal)
