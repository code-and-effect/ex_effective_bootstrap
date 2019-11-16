defmodule ExEffectiveBootstrap.Options do
  alias ExEffectiveBootstrap.Feedback
  alias Phoenix.HTML.Form

  defstruct wrapper: [class: "form-group"],
            label: [],
            input: [class: "form-control"],
            valid: [class: "valid-feedback"],
            invalid: [class: "invalid-feedback"],
            hint: [class: "form-text text-muted"],
            prepend: [class: "input-group-prepend"],
            append: [class: "input-group-append"]

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

  def build(options, form, field, opts \\ []) do
    %__MODULE__{
      wrapper: build_wrapper(form, field, options.wrapper, opts[:wrapper]),
      label: build_label(form, field, options.label, opts[:label]),
      valid: build_valid(form, field, options.valid, opts[:valid_feedback]),
      invalid: build_invalid(form, field, options.invalid, opts[:invalid_feedback]),
      hint: build_hint(form, field, options.hint, opts[:hint]),
      prepend: build_prepend(form, field, options.prepend, opts[:prepend]),
      append: build_append(form, field, options.append, opts[:append]),
      input: build_input(form, field, options.input, opts)
    }
  end

  defp build_wrapper(form, field, options, opts), do: merge(options, opts)

  defp build_label(form, field, options, opts) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:text, Form.humanize(field))
    |> put_blank(:for, Form.input_id(form, field))
  end

  defp build_label(form, field, options, opts) do
    build_label(form, field, options, [text: opts])
  end

  defp build_hint(form, field, options, opts) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:id, "#{Form.input_id(form, field)}_hint")
  end

  defp build_hint(form, field, options, opts) do
    build_hint(form, field, options, [text: opts])
  end

  defp build_prepend(form, field, options, opts) when is_list(opts) do
    IO.inspect("AAA")
    merge(options, opts)
  end

  defp build_prepend(form, field, options, opts) do
    IO.inspect("BBB")
    IO.inspect(opts)
    build_prepend(form, field, options, [text: opts])
  end

  defp build_append(form, field, options, opts) when is_list(opts) do
    merge(options, opts)
  end

  defp build_append(form, field, options, opts) do
    build_append(form, field, options, [text: opts])
  end

  defp build_valid(form, field, options, opts) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:text, Feedback.valid(form, field, options))
  end

  defp build_valid(form, field, options, opts) do
    build_valid(form, field, options, [text: opts])
  end

  defp build_invalid(form, field, options, opts) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:text, Feedback.invalid(form, field, options))
  end

  defp build_invalid(form, field, options, opts) do
    build_invalid(form, field, options, [text: opts])
  end

  defp build_input(form, field, options, opts) do
    drop = [:label, :as, :type, :valid_feedback, :invalid_feedback, :wrapper, :hint, :prepend, :append]

    validations = Form.input_validations(form, field)
    with_errors = input_with_errors_opts(form, field)
    with_hint = input_with_hint_opts(form, field, opts)

    Keyword.drop(opts, drop)
    |> merge(validations)
    |> merge(with_errors)
    |> merge(with_hint)
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

  defp put_blank(options, key, value) do
    if is_nil(options[key]), do: Keyword.put(options, key, value), else: options
  end
end
