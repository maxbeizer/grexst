defmodule Grexst do
  alias Grexst.Client

  def main(output, term) do
    Client.start_link
    Enum.map(1 .. Client.total_pages_of_gists, fn n ->
      %{body: b} = Client.get_gists(n)
      {:ok, body} = JSX.decode(b)
      IO.inspect(body)
    end)
end
