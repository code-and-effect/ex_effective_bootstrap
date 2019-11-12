defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm

  @valid_label "Look's good!"
  @invalid_label "is invalid"

# <div class="form-group">
#   <label for="user_name">Name</label>
#   <input class="form-control" required="required" type="text" name="user[name]" id="user_name">
#   <div class="invalid-feedback">can't be blank</div>
#   <div class="valid-feedback">Looks good!</div>
# </div>

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
    phoenix = PhxForm.input_validations(form, field)
    options = Keyword.drop(options, [:label, :as, :type, :valid_feedback, :invalid_feedback, :wrapper])

    default
    |> merge_options(phoenix)
    |> merge_options(options)
  end

  defp label_tag(_form, _field, false), do: []
  defp label_tag(form, field, label), do: PhxForm.label(form, field, label || humanize(field))

  defp input_tag(form, field, type, options) do
    apply(PhxForm, type, [form, field, options])
  end

  defp valid_tag(_form, _field, false), do: []
  defp valid_tag(_form, _field, label) do
    content_tag(:div, label || @valid_label, [class: "valid-feedback"])
  end

  defp invalid_tag(_form, _field, false), do: []
  defp invalid_tag(_form, _field, label) do
    content_tag(:div, label || @invalid_label, [class: "invalid-feedback"])
  end

  defp merge_options(nil, opts) when is_list(opts), do: opts
  defp merge_options(options, nil) when is_list(options), do: options
  defp merge_options(options, opts) when is_list(options) and is_list(opts) do
    Keyword.merge(options, opts) |> merge_class(options[:class], opts[:class])
  end

  defp merge_class(options, nil, nil), do: options
  defp merge_class(options, class, nil), do: Keyword.merge(options, [class: class])
  defp merge_class(options, nil, class), do: Keyword.merge(options, [class: class])
  defp merge_class(options, a, b), do: Keyword.merge(options, [class: "#{a} #{b}"])

end
