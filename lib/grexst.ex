defmodule Grexst do
  use Application
  alias Grexst.Client

  def start(_,_) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Grexst.RawURLsAgent, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: __MODULE__])
  end

  def main(output, term) do
    Grexst.RawURLsAgent.clear_urls
    IO.puts 'starting'
    Client.new(%{access_token: System.get_env("GREXST_TOKEN")})
    |> Client.get_gists
    |> Grexst.ContentHandler.get_urls
  end
end
