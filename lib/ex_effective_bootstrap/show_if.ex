defmodule ExEffectiveBootstrap.ShowIf do
  @moduledoc "The show_if helper for use within an effective_form"
  alias Phoenix.HTML.Form
  import Phoenix.HTML.Tag, only: [content_tag: 3]

  @doc """
  Automatically show/hide the content when the given form and field has the given value

  Examples:

  <%= input f, :status, select: ["active", "disabled"]

  <%= show_if(f, :status, "active") do %>
    <p>This is displayed when the status select field option is "active"</p>
  <% end %>
  """
  @spec show_if(Phoenix.HTML.Form.t(), atom, any, {:do, Phoenix.HTML.Safe.t()}) ::
          Phoenix.HTML.Safe.t()
  def show_if(form, field, value, do: content) do
    show = Map.get(form.data, field) == value

    class = [class: "effective-show-if"]
    style = if show, do: [], else: [style: "display: none;"]

    javascript = [
      "data-input-js-options":
        Jason.encode!(%{
          method_name: :show_if,
          name: Form.input_name(form, field),
          value: value
        })
    ]

    content_tag(:div, content, class ++ style ++ javascript)
  end

  @doc """
  Automatically show/hide the content when the given form and field has the given value
  """
  @spec hide_if(Phoenix.HTML.Form.t(), atom, any, {:do, Phoenix.HTML.Safe.t()}) ::
          Phoenix.HTML.Safe.t()
  def hide_if(form, field, value, do: content) do
    hide = Map.get(form.data, field) == value

    class = [class: "effective-hide-if"]
    style = if hide, do: [style: "display: none;"], else: []

    javascript = [
      "data-input-js-options":
        Jason.encode!(%{
          method_name: :hide_if,
          name: Form.input_name(form, field),
          value: value
        })
    ]

    content_tag(:div, content, class ++ style ++ javascript)
  end
end
