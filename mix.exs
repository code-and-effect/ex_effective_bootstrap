defmodule ExEffectiveBootstrap.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ex_effective_bootstrap,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      compilers: [:phoenix] ++ Mix.compilers(),
      deps: deps(),
      package: package(),
      source_url: "https://github.com/code-and-effect/ex_effective_bootstrap",
      name: "ExEffectiveBootstrap",
      description: "Everything your Phoenix Elixir app needs to use Twitter Bootstrap 4"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.3.0 or ~> 1.4.0"},
      {:phoenix_html, "~> 2.11"}
    ]
  end

  defp package do
    [
      maintainers: ["Code and Effect Inc."],
      licenses: ["MIT"],
      files: ~w(lib priv mix.exs package.json LICENSE.md README.md),
      links: %{github: "https://github.com/code-and-effect/ex_effective_bootstrap"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
