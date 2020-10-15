defmodule ExEffectiveBootstrap.Icons do
  @moduledoc """
  Use Feather and FontAwesome svg icons in your views"

  = icon(:check)
  """
  alias ExEffectiveBootstrap.Options

  # icon(:check, class: 'big-4')
  # icon('check', class: 'small-3')
  @spec icon(atom | String.t(), Keyword.t()) :: Phoenix.HTML.Safe.t()
  def icon(svg, opts \\ []) do
    opts =
      opts
      |> Options.merge(class: "eb-icon eb-icon-#{svg}")
      |> Enum.map(fn {key, value} -> "#{key}='#{value}'" end)
      |> Enum.join(" ")

    svg_path = Application.app_dir(:ex_effective_bootstrap, ["priv", "icons"])

    svg_tag =
      File.read!("#{svg_path}/#{svg}.svg")
      |> String.replace("svg", "svg #{opts}", global: false)

    {:safe, svg_tag}
  end
end
