defmodule Brzo.MixProject do
  use Mix.Project

  def project do
    [
      app: :brzo,
      version: "0.1.0",
      language: :erlang,
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers() ++ [:lfe],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_lfe, "0.2.0-rc3", app: false, only: [:dev, :test]},
      {:lfe, git: "https://github.com/rvirding/lfe.git", override: true}
    ]
  end
end
