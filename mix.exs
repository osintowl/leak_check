defmodule LeakCheck.MixProject do
  use Mix.Project

  def project do
    [
      app: :leak_check,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      files: ~(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["BSD-3-Clause"],
      links: %{"GitHub" => "https://github.com/nix2intel/leak_check"}
    ]
  end
end
