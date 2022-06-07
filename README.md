# Elixir Logging

An Elixir app demonstrating setting up structured logging.

## Getting it started

- Install Elixir with Erlang/OTP - [See `.tool-versions`](./.tool-versions).

  - [MacOs / Linux](https://www.pluralsight.com/guides/installing-elixir-erlang-with-asdf)
  - [Windows](https://elixir-lang.org/install.html)

- Once installed, run `mix local.hex --force && mix local.rebar --force` to get [Hex](https://hexdocs.pm/mix/Mix.Tasks.Local.Hex.html) and [Rebar](https://hexdocs.pm/mix/master/Mix.Tasks.Local.Rebar.html) installed.

- Set the needed environment variables. See [Environment Variables](#environment-variables) below for more information.

- Install dependencies with `mix deps.get`.

- Start the Phoenix endpoint with `mix phx.server` or in interactive mode with `iex -S mix phx.server` (preferred).

## Environment Variables

Environment variables may be set by adding the value to a `.env-dev` file in the root of the project. Make a copy of `.env-sample` and rename it appropriately. This file is not versioned in the repository. Alternately, they may of course be set at the command line.

The `CONSOLE_LOGGING` environment variable will be used to switch to unstructured logging.
