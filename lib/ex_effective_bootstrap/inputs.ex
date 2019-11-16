defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.Options
  alias Phoenix.HTML.Form

  defstruct label: nil,
            input: nil,
            valid: nil,
            invalid: nil,
            hint: nil,
            prepend: nil,
            append: nil

  def input(form, field, opts \\ []) do
    type = opts[:type] || opts[:as] || Form.input_type(form, field)
    effective_input(type, form, field, opts)
  end

  def build(type, form, field, options) do
    %__MODULE__{
      label: label_tag(options.label),
      valid: valid_tag(options.valid),
      invalid: invalid_tag(options.invalid),
      hint: hint_tag(options.hint),
      input: input_tag(type, form, field, options.input)
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

  defp input_tag(type, form, field, opts) do
    apply(Form, type, [form, field, opts])
  end

  def effective_input(:checkbox, form, field, opts) do
   options = %Options{
      wrapper: [class: "form-group custom-control custom-checkbox"],
      label: [class: "custom-control-label"],
      input: [class: "custom-control-input"],
    } |> Options.build(form, field, opts)

    tags = build(:checkbox, form, field, options)
    IO.inspect(tags)

    content_tag :div, options.wrapper do
      [tags.input, tags.label, tags.valid, tags.invalid, tags.hint]
    end


    # content_tag :div, class: "form-group custom-control custom-checkbox" do
    #   label = label_tag(form, field, opts.label, class: "custom-control-label")
    #   input = input_tag(form, field, :checkbox, class: "custom-control-input")
    #   valid = valid_tag(form, field, opts.valid)
    #   invalid = invalid_tag(form, field, opts.invalid)
    #   hint = hint_tag(form, field, opts.hint)

    #   [input, label, valid, invalid, hint]
    # end
  end

  # def effective_input(:email, form, field, options) do
  #   opts = Options.input_options(form, field, options)

  #   prepend = content_tag(:div, class: "input-group-prepend") do
  #     content_tag(:span, "@", class: "input-group-text")
  #   end

  #   label = label_tag(form, field, opts.label)
  #   input = input_tag(form, field, :email_input, opts.input)
  #   valid = valid_tag(form, field, opts.valid)
  #   invalid = invalid_tag(form, field, opts.invalid)
  #   hint = hint_tag(form, field, opts.hint)

  #   group = content_tag(:div, class: "input-group") do
  #     [prepend, input, valid, invalid]
  #   end

  #   content_tag :div, opts.wrapper do
  #     [label, group, hint]
  #   end
  # end

  def effective_input(type, form, field, opts) do
    options = Options.build(%Options{}, form, field, opts)
    tags = build(type, form, field, options)

    content_tag :div, options.wrapper do
      [tags.label, tags.input, tags.valid, tags.invalid, tags.hint]
    end
  end

end
