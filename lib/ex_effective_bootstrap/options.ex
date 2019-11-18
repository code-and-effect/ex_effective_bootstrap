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
    |> update_wrapper(form, field, opts[:wrapper])
    |> update_label(form, field, opts[:label])
    |> update_valid(form, field, opts[:valid_feedback])
    |> update_invalid(form, field, opts[:invalid_feedback])
    |> update_hint(form, field, opts[:hint])
    |> update_prepend(form, field, opts[:prepend])
    |> update_append(form, field, opts[:append])
    |> update_input_group(form, field, opts[:input_group])
    |> remove_input_group(form, field)
    |> update_input(form, field, opts)
    |> IO.inspect
  end

  defp update_type(options, form, field, opts) do
    put_in(options.type, input_type(form, field, opts))
  end

  defp update_wrapper(options, form, field, opts) do
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
    drop = [:label, :as, :input, :type, :valid_feedback, :invalid_feedback, :wrapper, :hint, :prepend, :append]

    merged_opts = merge(opts[:input], Keyword.drop(opts, drop))
    validations = Form.input_validations(form, field)
    with_errors = input_with_errors(form, field)
    with_hint = input_with_hint(form, field, opts)
    merged_opts = merged_opts |> merge(validations) |> merge(with_errors) |> merge(with_hint)

    put_in(options.input, merge(options.label, merged_opts))
  end

  defp update_valid(options, form, field, false) do
    put_in(options.valid, false)
  end

  defp update_valid(options, form, field, nil) do
    update_valid(options, form, field, [])
  end

  defp update_valid(options, form, field, opts) when is_list(opts) do
    opts = [text: Feedback.valid(form, field, opts)] |> merge(opts)
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
    opts = [text: Feedback.invalid(form, field, opts)] |> merge(opts)
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
    opts = ["aria-describedby": "#{Form.input_id(form, field)}_hint"] |> merge(opts)
    put_in(options.hint, merge(options.hint, opts))
  end

  defp update_hint(options, form, field, opts) do
    update_hint(options, form, field, [text: opts])
  end

  defp update_prepend(options, form, field, false) do
    put_in(options.prepend, false)
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


  #   defp label(options, opts, form, field) when is_list(opts) do
  #   merge(options, opts)
  #   |> put_blank(:text, Form.humanize(field))
  #   |> put_blank(:for, Form.input_id(form, field))
  # end

  # def update(options, key, form, field, opt) when is_nil(opt) do
  #   #update_in(options[key], fn x -> merge(x, opts[key]) end)
  #   options
  # end

  # def update(options, key, form, field, opt) when is_list(opts[key]) do
  #   update_in(options[key], fn x -> merge(x, opts[key]) end)
  # end

  # def update(options, key, form, field, opts) do
  #   update(options, key, form, field, [text: opts[key]])
  # end

  # def add_wrapper(options, form, field, opts) do
  #   update_in(options.wrapper, fn x -> merge(x, opts[:wrapper]) end)
  # end

    #get_and_update_in(options.wrapper, fn(x) -> {x, ExEffectiveBootstrap.Options.merge(x, opts) } end)
    # build
    # %__MODULE__{
    #   type: input_type(form, field, opts),
    #   wrapper: wrapper(options.wrapper, opts[:wrapper], form, field),
    #   label: label(options.label, opts[:label], form, field),
    #   input: input(options.input, opts, form, field),
    #   valid: valid(options.valid, opts[:valid_feedback], form, field),
    #   invalid: invalid(options.invalid, opts[:invalid_feedback], form, field),
    #   hint: hint(options.hint, opts[:hint], form, field),
    #   prepend: prepend(options.prepend, opts[:prepend], form, field),
    #   append: append(options.append, opts[:append], form, field),
    #   input_group: input_group(options.input_group, opts, form, field)
    # }
  # end


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

  defp input_group(options, opts, form, field) do
    options = merge(options, opts)

    if (options.prepend[:text] || options.append[:text]) do
      merge(options, enabled: true)
    else
      options
    end
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
