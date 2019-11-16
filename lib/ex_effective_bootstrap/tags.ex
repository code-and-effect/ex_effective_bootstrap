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

  def build(%Options{} = options, form, field) do
    tags = %__MODULE__{
      label: label(options.label) || [],
      input: input(form, field, options) || [],
      valid: valid(options.valid) || [],
      invalid: invalid(options.invalid) || [],
      hint: hint(options.hint) || [],
      prepend: prepend(options.prepend) || [],
      append: append(options.append) || [],
    }

    {tags, options}
  end

  defp label(options) do
    if options[:text], do: content_tag(:label, options[:text], Keyword.delete(options, :text))
  end

  defp input(form, field, options) do
    apply(Form, options.type, [form, field, options.input])
  end

  defp valid(options) do
    if options[:text], do: content_tag(:div, options[:text], Keyword.delete(options, :text))
  end

  defp invalid(options) do
    if options[:text], do: content_tag(:div, options[:text], Keyword.delete(options, :text))
  end

  defp hint(options) do
    if options[:text], do: content_tag(:small, options[:text], Keyword.delete(options, :text))
  end

  defp prepend(options) do
    if options[:text] do
      content_tag(:div, class: "input-group-prepend") do
        content_tag(:span, options[:text], Keyword.delete(options, :text))
      end
    end
  end

  defp append(options) do
    if options[:text] do
      content_tag(:div, class: "input-group-append") do
        content_tag(:span, options[:text], Keyword.delete(options, :text))
      end
    end
  end

end
