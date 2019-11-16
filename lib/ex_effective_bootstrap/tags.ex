defmodule ExEffectiveBootstrap.Tags do
  alias ExEffectiveBootstrap.Options
  alias Phoenix.HTML.Form
  import Phoenix.HTML.Tag, only: [content_tag: 3]

  defstruct label: nil,
            input: nil,
            valid: nil,
            invalid: nil,
            hint: nil,
            prepend: nil,
            append: nil

  def build(type, form, field, %Options{} = options) do
    %__MODULE__{
      label: label_tag(options.label),
      input: input_tag(type, form, field, options.input),
      valid: valid_tag(options.valid),
      invalid: invalid_tag(options.invalid),
      hint: hint_tag(options.hint),
      prepend: prepend_tag(options.prepend),
      append: append_tag(options.append)
    }
  end

  defp label_tag(opts) do
    if opts[:text], do: content_tag(:label, opts[:text], Keyword.delete(opts, :text)), else: []
  end

  defp valid_tag(opts) do
    if opts[:text], do: content_tag(:div, opts[:text], Keyword.delete(opts, :text)), else: []
  end

  defp invalid_tag(opts) do
    if opts[:text], do: content_tag(:div, opts[:text], Keyword.delete(opts, :text)), else: []
  end

  defp hint_tag(opts) do
    if opts[:text], do: content_tag(:small, opts[:text], Keyword.delete(opts, :text)), else: []
  end

  defp prepend_tag(opts) do
    if opts[:text] do
      content_tag(:div, class: "input-group-prepend") do
        content_tag(:span, opts[:text], Keyword.delete(opts, :text))
      end
    else
      []
    end
  end

  defp append_tag(opts) do
    if opts[:text] do
      content_tag(:div, class: "input-group-append") do
        content_tag(:span, opts[:text], Keyword.delete(opts, :text))
      end
    else
      []
    end
  end

  defp input_tag(type, form, field, opts) do
    apply(Form, type, [form, field, opts])
  end

end
