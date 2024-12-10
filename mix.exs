defmodule LeakCheck.MixProject do
  use Mix.Project

  @version "0.1.O"
  
  @source_url "https://github.com/nix2intel/leak_check"

  def project do
    [
      app: :leak_check,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "LeakCheck",
      source_url: @source_url
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
  	{:req, "~> 0.5.8"},
  	{:jason, "~> 1.4"},
  	{:ex_doc, "~> 0.35.1",  only: :dev, runtime: false}
    ]
  end
  
  defp package do
    [
      name: "leak_check",
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["BSD-3-Clause"],
      links: %{
        "GitHub" => @source_url,
      }
    ]
  end
  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
defp description do
  """
  An unofficial Elixir client for LeakCheck.io API v2. Search for leaked credentials and data breaches using LeakCheck's powerful search engine.

  LeakCheck™ and its API are properties of LeakCheck.io - this is a community-maintained client library.
  """
end

end
