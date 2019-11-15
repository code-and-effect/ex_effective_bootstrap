defmodule ExEffectiveBootstrap.Submit do
  use Phoenix.HTML
  alias ExEffectiveBootstrap.{Icons, Options}
  alias Phoenix.HTML.Form

  @doc """
  Generates a submit button to send the form.
  All options are forwarded to the underlying button tag.
  ## Examples
      submit "Submit"
      #=> <button type="submit">Submit</button>
  """
  # def effective_submit([do: _] = block_option), do: effective_submit([], block_option)

  # def effective_submit(_, opts \\ [])

  # def submit(opts, [do: _] = block_option) do
  #   opts = Keyword.put_new(opts, :type, "submit")

  #   content_tag(:button, opts, block_option)
  # end

  # def submit(value, opts) do
  #   opts = Keyword.put_new(opts, :type, "submit")

  #   content_tag(:button, value, opts)
  # end

  def effective_submit(value \\ "Save", opts \\ []) do
    defaults = [
      class: "effective-form-actions",
      onclick: "return EffectiveForm.onSubmitClick(this);"
    ]

    new_value = [Icons.icon(:spinner), Icons.icon(:check), Icons.icon(:times), content_tag(:span, value)]
    new_opts = Options.merge(opts, defaults)

    Form.submit(new_value, new_opts)
  end

  # def input(form, field, options \\ []) do
  #   opts = Options.input_options(form, field, options)

  #   content_tag :div, opts.wrapper do
  #     label = label_tag(form, field, opts.label)
  #     input = input_tag(form, field, opts.type, opts.input)
  #     valid = valid_tag(form, field, opts.valid)
  #     invalid = invalid_tag(form, field, opts.invalid)
  #     hint = hint_tag(form, field, opts.hint)

  #     [label, input, valid, invalid, hint]
  #   end
  # end

  # defp label_tag(_form, _field, false), do: []

  # defp label_tag(form, field, label) do
  #   Form.label(form, field, label || humanize(field))
  # end

  # defp input_tag(form, field, type, options) do
  #   apply(Form, type, [form, field, options])
  # end

  # defp valid_tag(_form, _field, false), do: []

  # defp valid_tag(_form, _field, label) do
  #   content_tag(:div, label, class: "valid-feedback")
  # end

  # defp invalid_tag(_form, _field, false), do: []

  # defp invalid_tag(_form, _field, label) do
  #   content_tag(:div, label, class: "invalid-feedback")
  # end

  # defp hint_tag(_form, _field, nil), do: []

  # defp hint_tag(form, field, label) do
  #   options = [class: "form-text text-muted", id: "#{input_id(form, field)}_hint"]
  #   content_tag(:small, label, options)
  # end
end
