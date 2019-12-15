defmodule ExEffectiveBootstrap.Navs do
  @moduledoc "Bootstrap nav (menu) helpers"
  use Phoenix.HTML

  @doc """
  Bootstrap nav_link for use on a navbar.
  Automatically puts in the "active" class when on conn.request_path

  Examples:

  <%= nav_link(@conn, "Home", to: "/") %>
  <%= nav_link(@conn, "Posts", to: Routes.post_path(@conn, :index)) %>
  """
  @spec nav_link(Plug.Conn.t(), String.t(), Keyword.t()) :: Phoenix.HTML.safe()
  def nav_link(%{request_path: request_path}, label, opts) do
    # Apply nav-item and active to the li tag
    nav_class =
      case request_path == opts[:to] do
        true -> ["nav-item", "active"]
        false -> ["nav-item"]
      end
      |> Enum.join(" ")

    # Apply nav-item to the a tag
    opts =
      case Keyword.get(opts, :class) do
        nil -> Keyword.put(opts, :class, "nav-link")
        other -> Keyword.put(opts, :class, "nav-link #{other}")
      end

    content_tag(:li, link(label, opts), class: nav_class)
  end
end
