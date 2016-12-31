defmodule Grexst do
  alias Grexst.Client

  def main(output, term) do
    Client.start_link(auth: System.get_env("GREXST_TOKEN"))
    # |> Client.get_gists
    # |> handle_gists
  end

  defp handle_gists({200, body}) do
    Enum.each(body, fn(gist) -> IO.puts gist["id"] end)
  end
  defp handle_gists(_), do: IO.puts "Nope"
end
