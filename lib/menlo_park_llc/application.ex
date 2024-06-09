defmodule MenloParkLlc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MenloParkLlcWeb.Telemetry,
      MenloParkLlc.Repo,
      {DNSCluster, query: Application.get_env(:menlo_park_llc, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MenloParkLlc.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MenloParkLlc.Finch},
      # Start a worker by calling: MenloParkLlc.Worker.start_link(arg)
      # {MenloParkLlc.Worker, arg},
      # Start to serve requests, typically the last entry
      MenloParkLlcWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MenloParkLlc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MenloParkLlcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
