defmodule GSM.MixProject do
  use Mix.Project

  @github "https://github.com/l1h3r/gsm"

  def project do
    [
      app: :gsm,
      version: "0.1.2",
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
    ~s(GSM-7 encoding for Elixir)
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["l1h3r"],
      licenses: ["MIT"],
      links: %{"Github" => @github}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.39", only: :dev},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      lint: ["dialyzer", "credo", "test"]
    ]
  end
end
