defmodule Base62Id.Mixfile do
  use Mix.Project

  def project do
    [
      app: :base62id,
      version: "0.1.0",
      elixir: "~> 1.6",
      description: description(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :postgrex, :ecto]
    ]
  end

  defp deps do
    [
      {:ecto, ">= 2.1.0"},
      {:postgrex, "~> 0.13.0"}
    ]
  end

  defp description do
    """
    Base62Id type for Ecto (actually stored as 8 byte integer)
    """
  end

  defp package do
    [
      name: :base62id,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Stas Versilov"],
      licenses: ["MIT License"],
      links: %{
        "GitHub" => "https://github.com/versilov/base62id"
      }
    ]
  end

  defp elixirc_paths(_), do: ["lib"]
end
