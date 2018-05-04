defmodule Gsm.MixProject do
  use Mix.Project

  @github ""

  def project do
    [
      app: :gsm,
      version: "0.1.0",
      elixir: "~> 1.6",
      name: "gsm",
      source_url: @github,
      homepage_url: @github,
      package: package(),
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    ""
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: [""],
      licenses: [""],
      links: %{"Github" => @github}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.18.3", only: :dev},
      {:credo, "~> 0.9.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.8.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      lint: ["dialyzer", "credo", "test"]
    ]
  end
end
