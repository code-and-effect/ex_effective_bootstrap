defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm
  alias ExEffectiveBootstrap.Options

  def input(form, field, options \\ []) do
    opts = Options.input_options(form, field, options)

    content_tag :div, opts.wrapper do
      label = label_tag(form, field, opts.label)
      input = input_tag(form, field, opts.type, opts.input)
      valid = valid_tag(form, field, opts.valid)
      invalid = invalid_tag(form, field, opts.invalid)

      [label, input, valid, invalid]
    end
  end

  defp label_tag(_form, _field, false), do: []
  defp label_tag(form, field, label) do
    PhxForm.label(form, field, label || humanize(field))
  end

  defp input_tag(form, field, type, options) do
    apply(PhxForm, type, [form, field, options])
  end

  defp valid_tag(_form, _field, false), do: []
  defp valid_tag(form, field, label) do
    content_tag(:div, label, class: "valid-feedback")
  end

  defp invalid_tag(_form, _field, false), do: []
  defp invalid_tag(form, field, label) do
    content_tag(:div, label, class: "invalid-feedback")
  end

end
