defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm

  @valid_label "Look's good!"
  @invalid_label "is invalid"

  def input(form, field, options \\ []) do
    opts = input_options(form, field, options)

    content_tag :div, opts.wrapper do
      label = label_tag(form, field, opts.label)
      input = input_tag(form, field, opts.type, opts.input)
      valid = valid_tag(form, field, opts.valid)
      invalid = invalid_tag(form, field, opts.invalid)

      [label, input, valid, invalid]
    end
  end

  defp label_tag(_form, _field, false), do: []
  defp label_tag(form, field, label) do
    PhxForm.label(form, field, label || humanize(field))
  end

  defp input_tag(form, field, type, options) do
    apply(PhxForm, type, [form, field, options])
  end

  defp valid_tag(_form, _field, false), do: []
  defp valid_tag(_form, _field, label) do
    content_tag(:div, label || @valid_label, [class: "valid-feedback"])
  end

  defp invalid_tag(_form, _field, false), do: []
  defp invalid_tag(form, field, nil) do
    errors = Keyword.get_values(form.source.errors, field)
    invalid_tag(form, field, invalid_label(errors))
  end
  defp invalid_tag(form, field, label) do
    content_tag(:div, label, [class: "invalid-feedback"])
  end

  defp invalid_label(errors) when length(errors) == 0, do: @invalid_label
  defp invalid_label(errors) when is_list(errors) do
    errors
    |> Enum.map(fn {error, _} -> error end)
    |> Enum.join(" and ")
  end

  defp input_options(form, field, options) do
    %{
      label: options[:label],
      type: (options[:as] || options[:type] || PhxForm.input_type(form, field)),
      valid: options[:valid_feedback],
      invalid: options[:invalid_feedback],
      wrapper: merge_options(options[:wrapper], [class: "form-group"]),
      input: input_field_options(form, field, options)
    }
  end

  defp input_field_options(form, field, options) do
    default = [class: "form-control"]
    options = Keyword.drop(options, [:label, :as, :type, :valid_feedback, :invalid_feedback, :wrapper])
    validations = PhxForm.input_validations(form, field)
    with_errors = with_errors_input_class(form, field)

    default
    |> merge_options(validations)
    |> merge_options(with_errors)
    |> merge_options(options)
  end

  defp with_errors_input_class(form, field) do
    cond do
      form.source.valid? == true -> []
      map_size(form.source.changes) == 0 -> []
      form.source.errors[field] -> [class: "is-invalid"]
      true -> [class: "is-valid"]
    end
  end

  defp merge_options(nil, opts) when is_list(opts), do: opts
  defp merge_options(options, nil) when is_list(options), do: options
  defp merge_options(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts)
    |> merge_class(options[:class], opts[:class])
  end

  defp merge_class(options, nil, nil), do: options
  defp merge_class(options, class, nil), do: Keyword.merge(options, [class: class])
  defp merge_class(options, nil, class), do: Keyword.merge(options, [class: class])
  defp merge_class(options, a, b), do: Keyword.merge(options, [class: "#{a} #{b}"])

end
