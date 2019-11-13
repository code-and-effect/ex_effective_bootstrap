defmodule ExEffectiveBootstrap.Icons do
  alias ExEffectiveBootstrap.Options

  @svg_path "deps/ex_effective_bootstrap/priv/icons"

  # icon(:check, class: 'big-4')
  # icon('check', class: 'small-3')
  def icon(svg, options \\ []) do
    options =
      options
      |> Options.merge(class: "eb-icon eb-icon-#{svg}")
      |> Enum.map(fn {key, value} -> "#{key}='#{value}'" end)
      |> Enum.join(" ")

    svg_tag =
      File.read!("#{@svg_path}/#{svg}.svg")
      |> String.replace("svg", "svg #{options}", global: false)

    {:safe, svg_tag}
  end
end
