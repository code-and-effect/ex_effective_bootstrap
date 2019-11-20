defmodule ExEffectiveBootstrap.Feedback do
  alias Phoenix.HTML.Form

  @valid "Look's good!"
  @invalid "is invalid"

  def valid(_form, _field, _options), do: @valid

  def invalid(form, field, options) do
    error = errors(form, field)
    validation = validations(form, field, options)
    feedback = feedbacks(form, field, options)

    invalid_text(error ++ validation ++ feedback)
  end

  defp invalid_text(messages) when length(messages) == 0, do: @invalid

  defp invalid_text(messages) do
    messages |> List.flatten() |> Enum.uniq() |> Enum.join(" and ")
  end

  defp errors(form, field) do
    Keyword.get_values(form.source.errors, field)
    |> Enum.map(fn {msg, opts} -> error(msg, opts) end)
  end

  defp error(msg, opts) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      if is_nil(value), do: acc, else: String.replace(acc, "%{#{key}}", "#{value}")
    end)
  end

  defp validations(form, field, options) do
    Form.input_validations(form, field)
    |> Keyword.put(:required, options.required)
    |> Enum.map(fn {msg, opts} -> validation(msg, opts) end)
  end

  defp validation(:required, true), do: ["can't be blank"]
  defp validation(:required, _), do: []
  defp validation(:minlength, count), do: ["should be at least #{count} character(s)"]
  defp validation(:maxlength, _), do: []
  defp validation(unknown, opts), do: ["unknown validation #{unknown} #{opts}"]

  defp feedbacks(form, field, options) do
    feedback(options.type)
  end

  defp feedback(:email_input), do: ["must be an email"]
  defp feedback(:tel), do: ["must be a phone number"]
  defp feedback(:password_input), do: []
  defp feedback(:text_input), do: []
  defp feedback(:checkbox), do: []
  defp feedback(:multiple_select), do: []
  defp feedback(:textarea), do: []
  defp feedback(unknown), do: []
end
