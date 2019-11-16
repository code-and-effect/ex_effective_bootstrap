defmodule ExEffectiveBootstrap.Options do
  alias ExEffectiveBootstrap.Feedback
  alias Phoenix.HTML.Form

  defstruct type: nil,
            wrapper: [class: "form-group"],
            label: [for: nil],
            input: [class: "form-control"],
            valid: [class: "valid-feedback"],
            invalid: [class: "invalid-feedback"],
            hint: [class: "form-text text-muted"],
            prepend: [class: "input-group-text"],
            append: [class: "input-group-text"]

  def form_options(form, opts \\ []) do
    default = [
      class: "effective-form needs-validation",
      novalidate: true,
      onsubmit: "return EffectiveForm.validate(this);"
    ]

    with_errors = if with_errors?(form), do: [class: "with-errors"]

    default
    |> merge(with_errors)
    |> merge(opts)
  end

  def input_type(form, field, opts \\ []) do
    opts[:type] || opts[:as] || Form.input_type(form, field)
  end

  def build(%__MODULE__{} = options, form, field, opts \\ []) do
    %__MODULE__{
      type: input_type(form, field, opts),
      wrapper: wrapper(options.wrapper, opts[:wrapper], form, field),
      label: label(options.label, opts[:label], form, field),
      input: input(options.input, opts, form, field),
      valid: valid(options.valid, opts[:valid_feedback], form, field),
      invalid: invalid(options.invalid, opts[:invalid_feedback], form, field),
      hint: hint(options.hint, opts[:hint], form, field),
      prepend: prepend(options.prepend, opts[:prepend], form, field),
      append: append(options.append, opts[:append], form, field),
    }
  end

  @spec merge(nil | maybe_improper_list, nil | maybe_improper_list) :: maybe_improper_list
  def merge(nil, opts) when is_list(opts), do: opts
  def merge(options, nil) when is_list(options), do: options
  def merge(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp wrapper(options, opts, form, field), do: merge(options, opts)

  defp label(options, opts, form, field) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:text, Form.humanize(field))
    |> put_blank(:for, Form.input_id(form, field))
  end

  defp label(options, opts, form, field) do
    label(options, [text: opts], form, field)
  end

  defp hint(options, opts, form, field) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:id, "#{Form.input_id(form, field)}_hint")
  end

  defp hint(options, opts, form, field) do
    hint(options, [text: opts], form, field)
  end

  defp prepend(options, opts, form, field) when is_list(opts) or is_nil(opts) do
    merge(options, opts)
  end

  defp prepend(options, opts, form, field) do
    prepend(options, [text: opts], form, field)
  end

  defp append(options, opts, form, field) when is_list(opts) or is_nil(opts) do
    merge(options, opts)
  end

  defp append(options, opts, form, field) do
    append(options, [text: opts], form, field)
  end

  defp valid(options, opts, form, field) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:text, Feedback.valid(form, field, options))
  end

  defp valid(options, opts, form, field) do
    valid(options, [text: opts], form, field)
  end

  defp invalid(options, opts, form, field) when is_list(opts) do
    merge(options, opts)
    |> put_blank(:text, Feedback.invalid(form, field, options))
  end

  defp invalid(options, opts, form, field) do
    invalid(options, [text: opts], form, field)
  end

  defp input(options, opts, form, field) do
    drop = [:label, :as, :input, :type, :valid_feedback, :invalid_feedback, :wrapper, :hint, :prepend, :append]

    merged_opts = merge(opts[:input], Keyword.drop(opts, drop))
    validations = Form.input_validations(form, field)
    with_errors = input_with_errors(form, field)
    with_hint = input_with_hint(form, field, opts)

    merged_opts
    |> merge(validations)
    |> merge(with_errors)
    |> merge(with_hint)
    |> merge(options)
  end

  defp input_with_errors(form, field) do
    cond do
      !with_errors?(form) -> []
      form.source.errors[field] -> [class: "is-invalid"]
      true -> [class: "is-valid"]
    end
  end

  defp input_with_hint(form, field, options) do
    if options[:hint], do: ["aria-describedby": "#{Form.input_id(form, field)}_hint"]
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

  defp put_blank(options, key, value) do
    if is_nil(options[key]), do: Keyword.put(options, key, value), else: options
  end
end
