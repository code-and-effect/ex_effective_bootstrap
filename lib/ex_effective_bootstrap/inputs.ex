defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.Options
  alias Phoenix.HTML.Form

  def input(form, field, opts \\ []) do
    type = opts[:type] || opts[:as] || Form.input_type(form, field)
    effective_input(type, form, field, opts)
  end

  def effective_input(:checkbox, form, field, opts) do
   options = %Options{
      wrapper: [class: "form-group custom-control custom-checkbox"],
      label: [class: "custom-control-label"],
      input: [class: "custom-control-input"],
    } |> Options.build(form, field, opts)

    IO.inspect(options)

    "CHECKBOX"

    # |> Options.input_options(form, field, options)


    # opts = Options.input_options(form, field, options)

    # content_tag :div, class: "form-group custom-control custom-checkbox" do
    #   label = label_tag(form, field, opts.label, class: "custom-control-label")
    #   input = input_tag(form, field, :checkbox, class: "custom-control-input")
    #   valid = valid_tag(form, field, opts.valid)
    #   invalid = invalid_tag(form, field, opts.invalid)
    #   hint = hint_tag(form, field, opts.hint)

    #   [input, label, valid, invalid, hint]
    # end
  end

  def effective_input(:email, form, field, options) do
    opts = Options.input_options(form, field, options)

    prepend = content_tag(:div, class: "input-group-prepend") do
      content_tag(:span, "@", class: "input-group-text")
    end

    label = label_tag(form, field, opts.label)
    input = input_tag(form, field, :email_input, opts.input)
    valid = valid_tag(form, field, opts.valid)
    invalid = invalid_tag(form, field, opts.invalid)
    hint = hint_tag(form, field, opts.hint)

    group = content_tag(:div, class: "input-group") do
      [prepend, input, valid, invalid]
    end

    content_tag :div, opts.wrapper do
      [label, group, hint]
    end
  end

  def effective_input(type, form, field, options) do
    opts = Options.input_options(form, field, options)

    content_tag :div, opts.wrapper do
      label = label_tag(form, field, opts.label)
      input = input_tag(form, field, type, opts.input)
      valid = valid_tag(form, field, opts.valid)
      invalid = invalid_tag(form, field, opts.invalid)
      hint = hint_tag(form, field, opts.hint)

      [label, input, valid, invalid, hint]
    end
  end

  defp label_tag(_form, _field, false), do: []

  defp label_tag(form, field, label, opts \\ []) do
    Form.label(form, field, label || humanize(field), opts)
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
