# ExEffectiveBootstrap

Everything your Phoenix Elixir app needs to get working with Twitter Bootstrap 4

View helpers and forms.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_effective_bootstrap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_effective_bootstrap, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_effective_bootstrap](https://hexdocs.pm/ex_effective_bootstrap).

Add to your `app_web/app_web.ex`:

```
def view do
  quote do
    use ExEffectiveBootstrap.View
  end
end
```

