defmodule Elastix.Mixfile do
  use Mix.Project

  @source_url "https://github.com/werbitzky/elastix"
  @version "0.10.0"

  def project do
    [
      app: :elastix,
      name: "Elastix",
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      applications: [:logger, :httpoison, :retry]
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.lcov": :test,
        quality: :test,
        "quality.ci": :test
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.4", only: [:test, :dev]},
      {:poison, "~> 3.0 or ~> 4.0", optional: true},
      {:httpoison, "~> 1.4"},
      {:retry, "~> 0.8"}
    ]
  end

  defp package do
    [
      description: "A DSL-free Elastic / Elasticsearch client for Elixir.",
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      maintainers: ["El Werbitzky", "evuez <helloevuez@gmail.com>"],
      licenses: ["WTFPL-2"],
      links: %{
        "Changelog" => "https://hexdocs.pm/elastix/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      compile: ["compile --warnings-as-errors"],
      quality: [
        "format --check-formatted",
        # "credo",
        "credo --mute-exit-status",
        # "xref graph --label compile-connected --fail-above 0",
        # Run `mix deps.clean --unlock --unused` to clean things identified below
        "deps.unlock --check-unused",
        # "hex.outdated",
        "hex.audit",
        # Waiting on fix for cowlib
        "deps.audit --ignore-package-names cowlib,mint,hackney",
        # "sobelow --exit --quiet --skip -i DOS.StringToAtom,Config.HTTPS,Config.HSTS",
        "sobelow --exit --quiet",
        "dialyzer --quiet-with-result"
      ],
      "quality.ci": [
        "format --check-formatted",
        # "deps.unlock --check-unused",
        # "hex.outdated",
        # "hex.audit",
        # Waiting on fix for cowlib
        "deps.audit --ignore-package-names cowlib,mint,hackney",
        "credo --mute-exit-status --all"
        # "sobelow --exit --quiet --skip -i DOS.StringToAtom,Config.HTTPS,Config.HSTS",
        # "dialyzer --quiet-with-result"
      ],
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        {:LICENSE, [title: "License"]},
        "README.md",
        "pages/custom-json-codec.md"
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
