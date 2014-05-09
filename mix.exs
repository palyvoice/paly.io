defmodule Palyio.Mixfile do
  use Mix.Project

  def project do
    [ app: :palyio,
      version: "0.0.1",
      build_per_environment: true,
      dynamos: [Palyio.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:cowboy, :dynamo],
      mod: { Palyio, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :dynamo, "~> 0.1.0-dev", github: "dynamo/dynamo" } ]
  end
end
