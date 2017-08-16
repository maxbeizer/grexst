defmodule Grexst do
  alias Grexst.Client

  def main(output, term) do
    %{raw_gist_urls: raw_gist_urls} = get_gist_urls()
  end

  defp get_gist_urls() do
    Client.start_link()
    Enum.each(1 .. Client.total_pages_of_gists(), fn n ->
      Client.get_gists(n)
    end)
    Client.state()
  end
end
