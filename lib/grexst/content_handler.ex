defmodule Grexst.ContentHandler do
  #get URLs from agent
  #get content from client with URL
  #grep content for term
  def get_urls(client) do
    do_get_urls(client)
  end

  defp do_get_urls(client) do
    client
    |> Grexst.Client.get_gist_content(Grexst.RawURLsAgent.get_url)
  end
end
