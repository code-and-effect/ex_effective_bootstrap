defmodule ExEffectiveBootstrap.Feedback do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm

  @valid "Look's good!"
  @invalid "is invalid"

  def valid(_form, _field, _options), do: @valid

  def invalid(form, field, options) do
    errors = input_errors(form, field)
    feedback = input_feedback(form, field, options)

    invalid_label(errors ++ feedback)
  end

  defp invalid_label(errors) when length(errors) == 0, do: @invalid
  defp invalid_label(errors) do
    errors |> List.flatten |> Enum.uniq |> Enum.join(" and ")
  end

  defp input_errors(form, field) do
    Keyword.get_values(form.source.errors, field)
    |> Enum.map(fn {msg, opts} -> error(msg, opts) end)
  end

  defp error(msg, opts) do
    Enum.reduce(opts, msg, fn({key, value}, acc) ->
      if is_nil(value), do: acc, else: String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp input_feedback(form, field, options) do
    input_type = options[:type] || options[:as] || PhxForm.input_type(form, field)
    feedback(input_type)
  end

  defp feedback(:email_input), do: ["must be an email"]
  defp feedback(:password_input), do: []
  defp feedback(unknown), do: ["unknown #{IO.puts(unknown)}"]

end
