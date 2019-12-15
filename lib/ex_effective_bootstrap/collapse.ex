defmodule ExEffectiveBootstrap.Collapse do
  @moduledoc "Bootstrap collapse"
  use Phoenix.HTML

  @doc """
  Bootstrap collapse. Expand/collapse additional content

  Examples:

  <%= collapse("Click to expand") do %>
    <p>This is the expanded content</p>
  <% end %>
  """
  @spec collapse(String.t() | Phoenix.HTML.Safe.t(), Keyword.t(), {:do, Phoenix.HTML.Safe.t()}) :: Phoenix.HTML.Safe.t()
  def collapse(label, opts \\ [], do: {:safe, content}) do
    id = "collapse#{:erlang.unique_integer()}"

    show = Keyword.get(opts, :show, false)
    link_class = Keyword.get(opts, :class, "")
    div_class = Keyword.get(opts, :div_class, "")
    card_class = Keyword.get(opts, :card_class, "card card-body my-2")

    div_class =
      ["collapse", div_class, if(show, do: "show", else: "")]
      |> Enum.join(" ")
      |> String.trim()

    link_opts = [
      class: link_class,
      href: "##{id}",
      role: "button",
      "data-toggle": "collapse",
      "aria-controls": "##{id}",
      "aria-expanded": show
    ]

    [
      content_tag(:a, label, link_opts),
      content_tag(:div, id: id, class: div_class) do
        content_tag(:div, raw(content), class: card_class)
      end
    ]
  end
end
