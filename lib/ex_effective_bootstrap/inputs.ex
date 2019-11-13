defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.Options
  alias Phoenix.HTML.Form

  def input(form, field, options \\ []) do
    opts = Options.input_options(form, field, options)

    content_tag :div, opts.wrapper do
      label = label_tag(form, field, opts.label)
      input = input_tag(form, field, opts.type, opts.input)
      valid = valid_tag(form, field, opts.valid)
      invalid = invalid_tag(form, field, opts.invalid)
      hint = hint_tag(form, field, opts.hint)

      [label, input, valid, invalid, hint]
    end
  end

  defp label_tag(_form, _field, false), do: []
  defp label_tag(form, field, label) do
    Form.label(form, field, label || humanize(field))
  end

  defp input_tag(form, field, type, options) do
    apply(Form, type, [form, field, options])
  end

  defp valid_tag(_form, _field, false), do: []
  defp valid_tag(_form, _field, label) do
    content_tag(:div, label, class: "valid-feedback")
  end

  defp invalid_tag(_form, _field, false), do: []
  defp invalid_tag(_form, _field, label) do
    content_tag(:div, label, class: "invalid-feedback")
  end

  defp hint_tag(_form, _field, nil), do: []
  defp hint_tag(form, field, label) do
    options = [class: "form-text text-muted", id: "#{input_id(form, field)}_hint"]
    content_tag(:small, label, options)
  end

end
