defmodule ExEffectiveBootstrap.Options do
  alias ExEffectiveBootstrap.Feedback
  alias Phoenix.HTML.Form

  defstruct type: nil,
            required: nil,
            wrapper: [class: "form-group"],
            label: [],
            input: [class: "form-control"],
            valid: [class: "valid-feedback"],
            invalid: [class: "invalid-feedback"],
            hint: [class: "form-text text-muted"],
            prepend: [class: "input-group-text"],
            append: [class: "input-group-text"],
            input_group: [class: "input-group"]

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
    options
    |> update_type(form, field, opts)
    |> update_required(form, field, opts)
    |> update_wrapper(form, field, opts[:wrapper])
    |> update_label(form, field, opts[:label])
    |> update_hint(form, field, opts[:hint])
    |> update_input(form, field, opts)
    |> update_valid(form, field, opts[:valid])
    |> update_invalid(form, field, opts[:invalid])
    |> update_prepend(form, field, opts[:prepend])
    |> update_append(form, field, opts[:append])
    |> update_input_group(form, field, opts[:input_group])
    |> remove_input_group(form, field)
  end

  defp update_type(options, form, field, opts) do
    put_in(options.type, input_type(form, field, opts))
  end

  defp update_required(options, form, field, opts \\ []) do
    required = cond do
      Keyword.has_key?(opts, :required) -> opts[:required]
      Keyword.has_key?(opts[:input] || [], :required) -> opts.input[:required]
      true -> Keyword.get(Form.input_validations(form, field), :required, false)
    end

    put_in(options.required, !!required)
  end

  defp update_wrapper(options, form, field, nil) do
    update_wrapper(options, form, field, [])
  end

  defp update_wrapper(options, form, field, opts) when is_list(opts) do
    put_in(options.wrapper, merge(options.wrapper, opts))
  end

  defp update_label(options, form, field, false) do
    put_in(options.label, false)
  end

  defp update_label(options, form, field, nil) do
    update_label(options, form, field, [])
  end

  defp update_label(options, form, field, opts) when is_list(opts) do
    opts = [text: Form.humanize(field), for: Form.input_id(form, field)] |> merge(opts)
    put_in(options.label, merge(options.label, opts))
  end

  defp update_label(options, form, field, opts) do
    update_label(options, form, field, [text: opts])
  end

  defp update_input(options, form, field, opts) do
    drop = [:label, :as, :input, :type, :valid, :invalid, :wrapper, :hint, :prepend, :append]
    opts = merge(opts[:input], Keyword.drop(opts, drop))

    validations = Form.input_validations(form, field)
    with_errors = input_with_errors(form, field)
    with_hint = if options.hint, do: input_with_hint(form, field) # Options

    merged_opts =
      []
      |> merge(validations)
      |> merge(with_errors)
      |> merge(with_hint)
      |> merge(opts)

    put_in(options.input, merge(options.input, merged_opts))
  end

  defp update_valid(options, form, field, false) do
    put_in(options.valid, false)
  end

  defp update_valid(options, form, field, nil) do
    update_valid(options, form, field, [])
  end

  defp update_valid(options, form, field, opts) when is_list(opts) do
    opts = [text: Feedback.valid(form, field, options)] |> merge(opts)
    put_in(options.valid, merge(options.valid, opts))
  end

  defp update_valid(options, form, field, opts) do
    update_valid(options, form, field, [text: opts])
  end

  defp update_invalid(options, form, field, false) do
    put_in(options.invalid, false)
  end

  defp update_invalid(options, form, field, nil) do
    update_invalid(options, form, field, [])
  end

  defp update_invalid(options, form, field, opts) when is_list(opts) do
    opts = [text: Feedback.invalid(form, field, options)] |> merge(opts)
    put_in(options.invalid, merge(options.invalid, opts))
  end

  defp update_invalid(options, form, field, opts) do
    update_invalid(options, form, field, [text: opts])
  end

  defp update_hint(options, form, field, false) do
    put_in(options.hint, false)
  end

  defp update_hint(options, form, field, nil) do
    put_in(options.hint, false)
  end

  defp update_hint(options, form, field, opts) when is_list(opts) do
    opts = [id: "#{Form.input_id(form, field)}_hint"] |> merge(opts)
    put_in(options.hint, merge(options.hint, opts))
  end

  defp update_hint(options, form, field, opts) do
    update_hint(options, form, field, [text: opts])
  end

  defp update_prepend(options, form, field, false) do
    put_in(options.prepend, false)
  end

  defp update_prepend(options, form, field, nil) do
    update_prepend(options, form, field, [])
  end

  defp update_prepend(options, form, field, opts) when is_list(opts) do
    put_in(options.prepend, merge(options.prepend, opts))
  end

  defp update_prepend(options, form, field, opts) do
    update_prepend(options, form, field, [text: opts])
  end

  defp update_append(options, form, field, false) do
    put_in(options.append, false)
  end

  defp update_append(options, form, field, nil) do
    update_append(options, form, field, [])
  end

  defp update_append(options, form, field, opts) when is_list(opts) do
    put_in(options.append, merge(options.append, opts))
  end

  defp update_append(options, form, field, opts) do
    update_append(options, form, field, [text: opts])
  end

  defp update_input_group(options, form, field, false) do
    put_in(options.input_group, false)
  end

  defp update_input_group(options, form, field, nil) do
    update_input_group(options, form, field, [])
  end

  defp update_input_group(options, form, field, opts) when is_list(opts) do
    put_in(options.input_group, merge(options.input_group, opts))
  end

  defp remove_input_group(options, form, field) do
    if options.append[:text] || options.prepend[:text] do
      options
    else
      options = put_in(options.append, false)
      options = put_in(options.prepend, false)
      options = put_in(options.input_group, false)
      options
    end
  end

  def merge(nil, opts) when is_list(opts), do: opts
  def merge(options, nil) when is_list(options), do: options
  def merge(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp input_with_errors(form, field) do
    cond do
      !with_errors?(form) -> []
      form.source.errors[field] -> [class: "is-invalid"]
      true -> [class: "is-valid"]
    end
  end

  defp input_with_hint(form, field) do
    ["aria-describedby": "#{Form.input_id(form, field)}_hint"]
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
