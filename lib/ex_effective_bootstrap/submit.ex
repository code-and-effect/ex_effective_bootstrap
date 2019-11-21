defmodule ExEffectiveBootstrap.Submit do
  @moduledoc "The submit button for an effective_form"
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Icons, Options}
  alias Phoenix.HTML.Form

  @spec effective_submit(any, Keyword.t()) :: Phoenix.HTML.Safe.t()
  def effective_submit(value \\ "Save", opts \\ []) do
    defaults = [
      class: "effective-submit",
      onclick: "return EffectiveForm.onSubmitClick(this);"
    ]

    new_value = [
      Icons.icon("spinner", style: "display: none;"),
      Icons.icon("form-success", style: "display: none;"),
      Icons.icon("form-error", style: "display: none;"),
      content_tag(:span, value)
    ]

    new_opts = Options.merge(opts, defaults)

    Form.submit(new_value, new_opts)
  end
end
