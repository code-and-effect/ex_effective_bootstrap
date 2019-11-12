defmodule ExEffectiveBootstrap.Options do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm
  alias ExEffectiveBootstrap.Feedback

  def form_options(form, options \\ []) do
    default = [
      class: "effective-form needs-validation",
      novalidate: true,
      onsubmit: "return EffectiveForm.validate(this);"
    ]

    with_errors = with_errors_class(form)

    default
    |> merge(with_errors)
    |> merge(options)
  end

  def input_options(form, field, options) do
    %{
      label: label_options(form, field, options),
      valid: valid_feedback_options(form, field, options),
      invalid: invalid_feedback_options(form, field, options),
      type: input_field_type(form, field, options),
      wrapper: wrapper_options(form, field, options),
      input: input_field_options(form, field, options),
      hint: hint_options(form, field, options)
    }
  end

  def merge(nil, opts) when is_list(opts), do: opts
  def merge(options, nil) when is_list(options), do: options
  def merge(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp label_options(_form, _field, options), do: options[:label]

  defp valid_feedback_options(form, field, options) do
    Keyword.get(options, :valid_feedback, Feedback.valid(form, field, options))
  end

  defp invalid_feedback_options(form, field, options) do
    Keyword.get(options, :invalid_feedback, Feedback.invalid(form, field, options))
  end

  defp input_field_type(form, field, options) do
    options[:type] || options[:as] || PhxForm.input_type(form, field)
  end

  defp wrapper_options(_form, _field, options) do
    merge(options[:wrapper], class: "form-group")
  end

  defp input_field_options(form, field, options) do
    default = [class: "form-control"]
    validations = PhxForm.input_validations(form, field)
    with_errors = with_errors_class(form, field)
    with_hint = with_hint_options(form, field, options)
    options = Keyword.drop(options, [:label, :as, :type, :valid_feedback, :invalid_feedback, :wrapper, :hint])

    default
    |> merge(validations)
    |> merge(with_errors)
    |> merge(with_hint)
    |> merge(options)
  end

  defp hint_options(_form, _field, options), do: options[:hint]

  defp with_errors_class(form) do
    if with_errors?(form), do: [class: "with-errors"], else: []
  end

  defp with_hint_options(form, field, options) do
    if options[:hint], do: ["aria-describedby": "#{input_id(form, field)}_hint"], else: []
  end

  defp with_errors_class(form, field) do
    cond do
      !with_errors?(form) -> []
      form.source.errors[field] -> [class: "is-invalid"]
      true -> [class: "is-valid"]
    end
  end

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
