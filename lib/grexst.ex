defmodule Grexst do
  use Application
  alias Grexst.Client

  def start(_,_) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Grexst.MatchesAgent, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: __MODULE__])
  end

  def main(output, term) do
    Grexst.MatchesAgent.clear_matches
    IO.puts 'starting'
    Client.new(%{access_token: System.get_env("GREXST_TOKEN")})
    |> Client.get_gists
    |> handle_gists
  end

  defp handle_gists({200, body}) do
    Enum.each(body, fn(gist) -> IO.puts gist["id"] end)
  end
  defp handle_gists(_), do: IO.puts "Nope"
end
