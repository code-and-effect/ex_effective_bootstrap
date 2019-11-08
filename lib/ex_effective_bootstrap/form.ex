defmodule ExEffectiveBootstrap.Form do
  use Phoenix.HTML
  alias Ecto.Changeset

  @class ["effective-form", "needs-validation"]
  @error ["with-errors"]
  @other [novalidate: true, onsubmit: "return EffectiveForm.validate(this);"]

  @spec effective_form_for(Phoenix.HTML.FormData.t(), String.t()) :: Phoenix.HTML.Form.t()
  def effective_form_for(form_data, action) do
    form_for(form_data, action, [])
  end

  @spec effective_form_for(Phoenix.HTML.FormData.t(), String.t(), Keyword.t()) ::
          Phoenix.HTML.Form.t()
  def effective_form_for(form_data, action, options) when is_list(options) do
    form_for(form_data, action, merge_options(form_data, action, options))
  end

  @spec effective_form_for(Phoenix.HTML.FormData.t(), String.t(), Keyword.t(), any) ::
          Phoenix.HTML.safe()
  def effective_form_for(form_data, action, options \\ [], fun) when is_function(fun, 1) do
    %{action: action, options: options} = form = effective_form_for(form_data, action, options)
    html_escape([form_tag(action, options), fun.(form), raw("</form>")])
  end

  defp merge_options(form_data, _action, options \\ []) do
    options
    |> merge_class(@class)
    |> merge_other(@other)
    |> merge_error(form_data)
  end

  defp merge_class(options, classes) do
    Keyword.update(options, :class, Enum.join(classes, " "), fn class ->
      Enum.join([class] ++ classes, " ")
    end)
  end

  defp merge_other(options, opts), do: Keyword.merge(options, opts)

  defp merge_error(options, %{changes: changes}) when map_size(changes) == 0, do: options
  defp merge_error(options, %{valid?: false}), do: merge_class(options, @error)
  defp merge_error(options, _), do: options
end
