defmodule ExEffectiveBootstrap.Tags do
  @moduledoc "Renders the html tags for each component"
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

  @type t :: %__MODULE__{
          label: Phoenix.HTML.Safe.t() | nil,
          input: Phoenix.HTML.Safe.t() | nil,
          valid: Phoenix.HTML.Safe.t() | nil,
          invalid: Phoenix.HTML.Safe.t() | nil,
          hint: Phoenix.HTML.Safe.t() | nil,
          prepend: Phoenix.HTML.Safe.t() | nil,
          append: Phoenix.HTML.Safe.t() | nil
        }

  @spec build(ExEffectiveBootstrap.Options.t(), Phoenix.HTML.Form.t() | atom, atom) ::
          {ExEffectiveBootstrap.Tags.t(), ExEffectiveBootstrap.Options.t()}
  def build(%Options{} = options, form, field) do
    tags = %__MODULE__{
      label: label(options.label) || [],
      input: input(form, field, options) || [],
      valid: valid(options.valid) || [],
      invalid: invalid(options.invalid) || [],
      hint: hint(options.hint) || [],
      prepend: prepend(options.prepend) || [],
      append: append(options.append) || []
    }

    {tags, options}
  end

  @spec label(ExEffectiveBootstrap.Options.t()) :: Phoenix.HTML.Safe.t() | nil
  def label(options) do
    if options, do: content_tag(:label, options[:text], Keyword.delete(options, :text))
  end

  defp input(form, field, %Options{type: :select} = options) do
    apply(Form, options.type, [form, field, options.select_options, options.input])
  end

  defp input(form, field, %Options{type: :multiple_select} = options) do
    apply(Form, options.type, [form, field, options.select_options, options.input])
  end

  defp input(form, field, %Options{type: :radios} = options) do
    if options.custom_control[:buttons] do
      radio_buttons(form, field, options)
    else
      radio_inputs(form, field, options)
    end
  end

  defp input(form, field, %Options{type: :static_field} = options) do
    content = options.input[:value] || Map.get(form.data, field)
    content_tag(:p, content, Keyword.delete(options.input, :value))
  end

  defp input(form, field, options) do
    apply(Form, options.type, [form, field, options.input])
  end

  defp valid(options) do
    if options, do: content_tag(:div, options[:text], Keyword.delete(options, :text))
  end

  defp invalid(options) do
    if options, do: content_tag(:div, options[:text], Keyword.delete(options, :text))
  end

  defp hint(options) do
    if options, do: content_tag(:small, options[:text], Keyword.delete(options, :text))
  end

  defp prepend(options) do
    if options do
      content_tag(:div, class: "input-group-prepend") do
        content_tag(:span, options[:text], Keyword.delete(options, :text))
      end
    end
  end

  defp append(options) do
    if options do
      content_tag(:div, class: "input-group-append") do
        content_tag(:span, options[:text], Keyword.delete(options, :text))
      end
    end
  end

  defp radio_buttons(form, field, options) do
    hidden = Form.hidden_input(form, field, id: nil, value: "")

    radios = Enum.map(options.select_options, fn {key, value} ->
      unique_id = "#{Form.input_id(form, field)}_#{:erlang.unique_integer()}"

      custom_input = Options.merge(options.custom_control[:input], options.input) |> Options.merge(id: unique_id)
      custom_label = Options.merge(options.custom_control[:label], for: unique_id)

      input = Form.radio_button(form, field, value, custom_input)
      text = to_string(key)

      content_tag(:label, [input, text], custom_label)
    end)

    content_tag(:div, [hidden] ++ radios, options.custom_control[:wrapper])
  end

  defp radio_inputs(form, field, options) do
    hidden = Form.hidden_input(form, field, id: nil, value: "")

    radios = Enum.map(options.select_options, fn {key, value} ->
      unique_id = "#{Form.input_id(form, field)}_#{:erlang.unique_integer()}"

      custom_input = Options.merge(options.custom_control[:input], options.input) |> Options.merge(id: unique_id)
      custom_label = Options.merge(options.custom_control[:label], for: unique_id)

      input = Form.radio_button(form, field, value, custom_input)
      label = content_tag(:label, key, custom_label)

      content_tag(:div, [input, label], options.custom_control[:wrapper])
    end)

    [hidden] ++ radios
  end

end
