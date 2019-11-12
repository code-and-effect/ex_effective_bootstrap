defmodule ExEffectiveBootstrap.Feedback do
  use Phoenix.HTML
  alias Phoenix.HTML.Form, as: PhxForm

  @valid "Look's good!"
  @invalid "is invalid"

  def valid(_form, _field), do: @valid

  def invalid(form, field) do
    errors = if map_size(form.source.changes) > 0 do
      Keyword.get_values(form.source.errors, field)
      |> Enum.map(fn {msg, opts} -> error_message(msg, opts) end)
    else
      # PhxForm.input_validations(form, field)
      # |> Enum.map(fn {msg, opts} -> invalid_message(msg, opts) end)
    end

    IO.inspect("#{field}")
    IO.inspect(errors)

    #invalid_label(errors)
    "can't be blank"
  end

  defp invalid_label(errors) when length(errors) == 0, do: @invalid_label
  defp invalid_label(errors) when is_list(errors) do
    Enum.join(errors, " and ")
  end

  defp error_message(msg, opts) do
    Enum.reduce(opts, msg, fn({key, value}, acc) ->
      if is_nil(value), do: acc, else: String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp invalid_message(msg, opts) do
    IO.inspect("invalid message")
    IO.inspect(msg)
    IO.inspect(opts)

    Enum.reduce(opts, msg, fn({key, value}, acc) ->
      if is_nil(value) or is_boolean(value), do: acc, else: String.replace(acc, "%{#{key}}", to_string(value))
    end)

  end

end
