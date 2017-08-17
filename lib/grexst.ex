defmodule Grexst do
  alias Grexst.Client

  def main(output, term) do
    %{gists_info: gists_info} = get_gists_info()
  end

  defp get_gists_info() do
    Client.start_link()
    Enum.each(1 .. Client.total_pages_of_gists(), fn n ->
      Client.get_gists(n)
    end)
    Client.state()
  end
end
