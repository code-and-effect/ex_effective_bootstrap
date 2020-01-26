defmodule ExEffectiveBootstrap.Errors do
  @moduledoc "Helper functions to traverse and work with error messages"

  @spec get(map, atom) :: binary()
  @spec get(map) :: binary()
  def get(%{errors: errors}, field) do
    Enum.map(Keyword.get_values(errors, field), fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.join(" and ")
  end

  def get(%{errors: errors}) do
    Enum.map(errors, fn {field, {msg, opts}} ->
      field_name(field) <>
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.join(" and ")
  end

  defp field_name(:base), do: ""
  defp field_name(nil), do: ""
  defp field_name(field), do: "#{field} "
end
