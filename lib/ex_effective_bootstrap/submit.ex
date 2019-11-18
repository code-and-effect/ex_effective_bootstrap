defmodule ExEffectiveBootstrap.Submit do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Icons, Options}
  alias Phoenix.HTML.Form

  def effective_submit(value \\ "Save", opts \\ []) do
    defaults = [
      class: "effective-submit",
      onclick: "return EffectiveForm.onSubmitClick(this);"
    ]

    new_value = [
      Icons.icon(:spinner, style: "display: none;"),
      Icons.icon(:check, style: "display: none;"),
      Icons.icon(:x, style: "display: none;"),
      content_tag(:span, value)
    ]

    new_opts = Options.merge(opts, defaults)

    Form.submit(new_value, new_opts)
  end
end
