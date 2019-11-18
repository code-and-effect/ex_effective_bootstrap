defmodule ExEffectiveBootstrap.Icons do
  alias ExEffectiveBootstrap.Options

  @svg_path "deps/ex_effective_bootstrap/priv/icons"

  # icon(:check, class: 'big-4')
  # icon('check', class: 'small-3')
  def icon(svg, opts \\ []) do
    opts =
      opts
      |> Options.merge(class: "eb-icon eb-icon-#{svg}")
      |> Enum.map(fn {key, value} -> "#{key}='#{value}'" end)
      |> Enum.join(" ")

    svg_tag =
      File.read!("#{@svg_path}/#{svg}.svg")
      |> String.replace("svg", "svg #{opts}", global: false)

    {:safe, svg_tag}
  end
end
