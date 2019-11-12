defmodule ExEffectiveBootstrap.Inputs do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm


# <div class="form-group">
#   <label for="user_name">Name</label>
#   <input class="form-control" required="required" type="text" name="user[name]" id="user_name">
#   <div class="invalid-feedback">can't be blank</div>
#   <div class="valid-feedback">Looks good!</div>
# </div>

  def input(form, field, options \\ []) do
    opts = input_options(form, field, options)

    content_tag :div, opts.wrapper do
      label = PhxForm.label(form, field, opts.label)
      input = apply(PhxForm, opts.type, [form, field, opts.input])
      valid = feedback_valid(form, field, opts.feedback_valid)
      invalid = feedback_invalid(form, field, opts.feedback_invalid)

      [label, input, valid, invalid]
    end
  end

  defp input_options(form, field, options) do
    %{
      type: (options[:as] || options[:type] || PhxForm.input_type(form, field)),
      input: [class: "form-control", required: true],
      label: humanize(field),
      wrapper: [class: "form-group"],
      feedback_valid: "Look's good!",
      feedback_invalid: "can't be blank",
    }
  end

  defp feedback_valid(form, _, false), do: []
  defp feedback_valid(form, _, label) do
    content_tag(:div, label, [class: "valid-feedback"])
  end

  defp feedback_invalid(form, _, false), do: []
  defp feedback_invalid(form, _, label) do
    content_tag(:div, label, [class: "invalid-feedback"])
  end

end
