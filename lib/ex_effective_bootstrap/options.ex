defmodule ExEffectiveBootstrap.Options do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm

  def input_options(form, field, options) do
    %{
      label: options[:label],
      valid: options[:valid_feedback],
      invalid: options[:invalid_feedback],
      input: input_field_options(form, field, options),
      type: input_field_type(form, field, options),
      wrapper: wrapper_options(form, field, options),
    }
  end

  def input_field_type(form, field, options) do
    options[:as] || options[:type] || PhxForm.input_type(form, field)
  end

  defp wrapper_options(_, _, options) do
    merge_options(options[:wrapper], class: "form-group")
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
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp merge_class(options, nil, nil), do: options
  defp merge_class(options, class, nil), do: Keyword.merge(options, class: class)
  defp merge_class(options, nil, class), do: Keyword.merge(options, class: class)
  defp merge_class(options, a, b), do: Keyword.merge(options, class: "#{a} #{b}")

end
