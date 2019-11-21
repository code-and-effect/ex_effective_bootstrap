# ExEffectiveBootstrap

Everything your Phoenix Elixir app needs to get working with Twitter Bootstrap 4.

Forms, icons, and view helpers.

## Installation

Add `ex_effective_bootstrap` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_effective_bootstrap, "~> 0.1.0"}
  ]
end
```

Then `mix deps.get`

## Setup

Add to your `app_web/app_web.ex`:

```
def view do
  quote do
    use Phoenix.HTML
    use ExEffectiveBootstrap.View
  end
end
```

Add to your `assets/package.json`:

```
"dependencies": {
  "bootstrap": "^4.3.1",
  "jquery": "^3.4.1",
  "popper.js": "^1.16.0",
  "phoenix": "file:../deps/phoenix",
  "phoenix_html": "file:../deps/phoenix_html",
  "ex_effective_bootstrap": "file../deps/ex_effective_bootstrap"
}
```

Add to your `app.js`:

```
import "bootstrap"
import "phoenix_html"
import "ex_effective_bootstrap"
```

Then in the `app/assets/` folder, `npm install`. Good luck.

Sanity check the javascript is working in the browser console:

```
console.log($.fn.jquery)
"3.4.1"

console.log(EffectiveForm.version())
"0.1.0"
```

Add to your `app.scss`:

```
@import "../node_modules/bootstrap/scss/bootstrap";
@import "../../deps/ex_effective_bootstrap/priv/static/ex_effective_bootstrap";
```

You should now have access to a wide range of beautiful, effective forms inputs and time saving view helpers!

## Forms

Use `effective_form_for`, a light wrapper around phoenix `form_for`, and the `input f` syntax for
[Bootstrap4 Forms](https://getbootstrap.com/docs/4.0/components/forms/) html-exact forms with
client side validation.

```
<%= effective_form_for @changeset, @action, fn f -> %>
  <%= input f, :email %>
  <%= input f, :password %>
  <%= effective_submit "Save" %>
<% end %>
```

or

```
<%= f = effective_form_for @changeset, @action %>
  <%= input f, :name, hint: "This name will be used throughout the site" %>
  <%= input f, :description, label: "Description", class: "special-class" %>
  <%= input f, :notes, as: :textarea, rows: 9 %>
  <%= input f, :category, select: ["Group A", "Group B", "Group C"], selected: "Group B" %>
  <%= input f, :regions, multiple_select: ["Region A", "Region B", "Region C"] %>
  <%= effective_submit() %>
</form>
```

## Form inputs

The following form inputs have been implemented, basically matching
[Phoenix.HTML.Form](https://github.com/phoenixframework/phoenix_html/blob/master/lib/phoenix_html/form.ex)

The `as: type` is totally optional, `input` will automatically detect the correct input type most of the time.

```
<%= input f, :foo, as: :text_input %>
<%= input f, :foo, as: :email_input %>
<%= input f, :foo, as: :number_input %>
<%= input f, :foo, as: :password_input %>
<%= input f, :foo, as: :url_input %>
<%= input f, :foo, as: :search_input %>
<%= input f, :foo, as: :telephone_input %>
<%= input f, :foo, as: :date_input %>
<%= input f, :foo, as: :textarea %>
<%= input f, :foo, as: :file_input %>
<%= input f, :foo, as: :checkbox %>
<%= input f, :foo, select: options %>
<%= input f, :foo, multiple_select: options %>
<%= input f, :foo, checks: options %> # TODO
<%= input f, :foo, radios: options %> # TODO
<%= input f, :foo, as: :time_input %> # TODO
<%= input f, :foo, as: :radio_button %> # TODO
```

Every input can be passed any options, such as:

```
<%= input f, :foo, label: "Nice Foo", hint: "Accept only the best", valid: "Looks great!", invalid: "Bad foo!" %>
<%= input f, :foo, "data-input-foo": "bar", class: "input-foo", wrapper: ["data-wrapper-foo": "bar", class: "wrap-foo"] %>
```

Using `append` and `prepend` can be fun to make input groups:

```
<%= input f, :song, prepend: icon(:music) %>
<%= input f, :song, prepend: [text: [icon(:music), "Song:"], class: "my-song-input-group"] %>
```

## Icons

Unfortunately, Bootstrap 4 dropped support for glyphicons, so we package a combination of [Feather Icons](https://feathericons.com) and [FontAwesome](https://fontawesome.com) .svg images (no webfonts).

```
<%= icon("check") %> # <svg class='eb-icon eb-icon-check' ...>
<%= icon("x", class: "small-1") %>
<%= icon("wifi", class: "big-3") %>

<%= link ["Next", icon("arrow-right")], to: "/", class: "btn btn-primary" %>
```

[List of all available icons](https://github.com/code-and-effect/ex_effective_bootstrap/tree/master/priv/icons)

## View Helpers

Coming soon.

## Hexcellent Documentation

TODO

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_effective_bootstrap](https://hexdocs.pm/ex_effective_bootstrap).


## License

MIT License.  Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

[Feather icons](https://github.com/feathericons/feather#license) are licensed under the [MIT License](https://opensource.org/licenses/MIT).

[FontAwesome icons](https://fontawesome.com/license) are licensed under the [CC BY 4.0 License](https://creativecommons.org/licenses/by/4.0/) and require this attribution.

## Credits

The authors of this gem are not associated with any of the awesome projects used by this gem.

We are just extending these existing community projects for ease of use with Elixir and Phoenix Forms.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request

