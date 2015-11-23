defmodule Grexst do
  alias Grexst.Client

  def main(output, term) do
    Client.new(%{access_token: System.get_env("GREXST_TOKEN")})
    |> fetch
  end

  defp fetch(client) do
    case Client.get_gists(client) do
      {200, body} -> Enum.each(body, fn(gist) -> IO.puts gist["id"] end)
      _           -> IO.puts "Nope"
    end
  end
end
