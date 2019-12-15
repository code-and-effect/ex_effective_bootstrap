defmodule ExEffectiveBootstrap.Tabs do
  @moduledoc "Bootstrap tabs"
  use Phoenix.HTML

  @doc """
  Bootstrap tabs

  <%= tabs(active: "Two", class: "asdf") do %>
    <%= tab("One") do %>
      <p>This is tab one</p>
    <% end %>

    <%= tab("Two") do %>
      <p>This is tab two</p>
    <% end %>
  <% end %>
  """
  @spec tabs(Keyword.t(), {:do, Phoenix.HTML.Safe.t()}) :: Phoenix.HTML.Safe.t()
  def tabs(opts \\ [], do: {:safe, tabs_content}) do
    # Either :first, or a String matching the tab label
    active = Keyword.get(opts, :active, :first)
    navclass = String.trim("nav nav-tabs #{Keyword.get(opts, :class, "")}")

    nav_opts = [class: navclass, role: "tablist"] ++ Keyword.drop(opts, [:class, :active])
    div_opts = [class: "tab-content"]

    content = tabs_content |> Enum.to_list() |> Enum.filter(fn x -> is_list(x) end)
    index = tabs_find_index(content, active) || 0

    navs = content |> tabs_get_navs |> tabs_activate_navs(index) |> raw
    divs = content |> tabs_get_divs |> tabs_activate_divs(index) |> raw

    nav_tag = content_tag(:ul, navs, nav_opts) |> safe_to_string
    div_tag = content_tag(:div, divs, div_opts) |> safe_to_string

    {:safe, nav_tag <> div_tag}
  end

  @doc """
  Individual Bootstrap tab, works within tabs helper"

  Examples:

  <%= tabs do %>
    <%= tab "One" %>
    <%= tab "Two", 30 %>
    <%= tab "Three", content_tag(:span, 24, class: "badge badge-info") %>
  <% end %>
  """
  @spec tab(String.t(), any, {:do, Phoenix.HTML.Safe.t()}) :: Phoenix.HTML.Safe.t()
  def tab(label, badge \\ nil, [do: _] = block) do
    id = label |> String.downcase() |> String.replace(" ", "-")
    controls = Kernel.to_charlist(id) |> Enum.sum()

    nav_opts = [
      class: "nav-link",
      id: "tab-#{id}-#{controls}",
      role: "tab",
      href: "##{id}-#{controls}",
      "data-toggle": "tab",
      "aria-controls": "#{id}-#{controls}",
      "aria-selected": false
    ]

    div_opts = [
      class: "tab-pane fade",
      id: "#{id}-#{controls}",
      role: "tabpanel",
      "aria-labelledby": "tab-#{id}-#{controls}"
    ]

    label =
      case badge do
        nil -> label
        {:safe, _} -> [label, " ", badge]
        _ -> [label, " ", content_tag(:span, badge, class: "badge badge-info")]
      end

    nav_tag = content_tag(:li, content_tag(:a, label, nav_opts), class: "nav-item")
    div_tag = content_tag(:div, div_opts, block)

    [nav_tag, div_tag]
  end

  defp tabs_get_navs(list), do: list |> Enum.map(&List.first/1)
  defp tabs_get_divs(list), do: list |> Enum.map(&List.last/1)

  defp tabs_find_index(_, active) when active == :first, do: 0

  defp tabs_find_index(list, active) do
    list
    |> tabs_get_navs
    |> Enum.find_index(fn x -> x |> List.flatten() |> Enum.member?(active) end)
  end

  defp tabs_activate_navs(list, index), do: list |> List.update_at(index, &tabs_activate_nav/1)
  defp tabs_activate_divs(list, index), do: list |> List.update_at(index, &tabs_activate_div/1)

  defp tabs_activate_nav(tags) do
    tags |> to_string |> String.replace("nav-link", "nav-link active", global: false)
  end

  defp tabs_activate_div(tags) do
    tags |> to_string |> String.replace("tab-pane", "tab-pane show active", global: false)
  end
end
