defmodule ExEffectiveBootstrap.Options do
  alias ExEffectiveBootstrap.Feedback
  alias Phoenix.HTML.Form

  def form_options(form, options \\ []) do
    default = [
      class: "effective-form needs-validation",
      novalidate: true,
      onsubmit: "return EffectiveForm.validate(this);"
    ]

    with_errors = if with_errors?(form), do: [class: "with-errors"]

    default
    |> merge(with_errors)
    |> merge(options)
  end

  def input_options(form, field, options) do
    %{
      type: type_opts(form, field, options),
      wrapper: wrapper_opts(form, field, options),
      label: label_opts(form, field, options),
      input: input_opts(form, field, options),
      valid: valid_feedback_opts(form, field, options),
      invalid: invalid_feedback_opts(form, field, options),
      hint: hint_opts(form, field, options)
    }
  end

  def merge(nil, opts) when is_list(opts), do: opts
  def merge(options, nil) when is_list(options), do: options

  def merge(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp type_opts(form, field, options) do
    options[:type] || options[:as] || Form.input_type(form, field)
  end

  defp wrapper_opts(_form, _field, options) do
    merge(options[:wrapper], class: "form-group")
  end

  defp label_opts(_form, _field, options), do: options[:label]

  defp input_opts(form, field, options) do
    default = [class: "form-control"]
    drop = [:label, :as, :type, :valid_feedback, :invalid_feedback, :wrapper, :hint]

    validations = Form.input_validations(form, field)
    with_errors = input_with_errors_opts(form, field)
    with_hint = input_with_hint_opts(form, field, options)
    options = Keyword.drop(options, drop)

    default
    |> merge(validations)
    |> merge(with_errors)
    |> merge(with_hint)
    |> merge(options)
  end

  defp input_with_errors_opts(form, field) do
    cond do
      !with_errors?(form) -> []
      form.source.errors[field] -> [class: "is-invalid"]
      true -> [class: "is-valid"]
    end
  end

  defp input_with_hint_opts(form, field, options) do
    if options[:hint], do: ["aria-describedby": "#{Form.input_id(form, field)}_hint"], else: []
  end

  defp valid_feedback_opts(form, field, options) do
    Keyword.get(options, :valid_feedback, Feedback.valid(form, field, options))
  end

  defp invalid_feedback_opts(form, field, options) do
    Keyword.get(options, :invalid_feedback, Feedback.invalid(form, field, options))
  end

  defp hint_opts(_form, _field, options), do: options[:hint]

  # submitted with errors
  defp with_errors?(%Phoenix.HTML.Form{source: source}), do: with_errors?(source)

  defp with_errors?(%Ecto.Changeset{} = source) do
    !source.valid? && map_size(source.changes) > 0
  end

  defp merge_class(options, nil, nil), do: options
  defp merge_class(options, class, nil), do: Keyword.merge(options, class: class)
  defp merge_class(options, nil, class), do: Keyword.merge(options, class: class)
  defp merge_class(options, a, b), do: Keyword.merge(options, class: "#{a} #{b}")
end
