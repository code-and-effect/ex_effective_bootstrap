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

Add to your `assets/package.json`, underneath `phoenix_html` the following:

```
"dependencies": {
  "bootstrap": "^4.3.1",
  "jquery": "^3.4.1",
  "phoenix": "file:../deps/phoenix",
  "phoenix_html": "file:../deps/phoenix_html",
  "phoenix_live_view": "file:../deps/phoenix_live_view",
  "popper.js": "^1.16.0",
  "ex_effective_bootstrap": "file../deps/ex_effective_bootstrap"
}
```

Link the deps:

```
~/Sites/tradesway/deps: ln -sf ../../ex_effective_bootstrap/
```

cd assets/
npm install

Add to your `app.js`:

```
import "bootstrap"
import "phoenix_html"
import "ex_effective_bootstrap"
```

cd assets\
npm install
npm run start


```
<%= effective_form_for @changeset, @action, fn a -> %>
  <%= bootstrap_input a, :email, :email %>
  <%= bootstrap_input a, :password, :password %>

  <%= submit "Sign in", class: "btn-form btn-block" %>
<% end %>

<hr>

<%= b = effective_form_for @changeset, @action, [class: "asdf"] %>
  <%= bootstrap_input b, :email, :email %>
  <%= bootstrap_input b, :password, :password %>
  <%= submit "Sign in", class: "btn-form btn-block" %>
</form>

<hr>

<%= c = effective_form_for @changeset, @action %>
  <%= bootstrap_input b, :email, :email %>
  <%= bootstrap_input b, :password, :password %>
  <%= submit "Sign in", class: "btn-form btn-block" %>
</form>
```
