defmodule Grexst.Client do
  require IEx
  use HTTPoison.Base
  defstruct auth: nil, endpoint: "https://api.github.com/gists"
  @user_agent [{"User-agent", "grexst"}]

  def new(auth), do: %__MODULE__{auth: auth}

  def get_gists(client, page \\ 1), do: do_get_gists(client, page)

  defp do_get_gists(client, page) do
    url  = url(client.endpoint, page)
    body = request(:get, url, client.auth)

    case body do
      nil -> IO.puts "End of gists"
      _   -> get_gists(client, page + 1)
    end
  end

  defp process_response(%{status_code: 200} = response) do
    {_atom, body} = JSX.decode response.body
    length        = length(body)

    if length == 0, do: body = nil

    body
  end

  defp url(endpoint, page), do: endpoint <> "?page=#{page}"

  defp authorization_header(%{access_token: token}, headers) do
    headers ++ [{"Authorization", "token #{token}"}]
  end

  defp request(method, url, auth, body \\ "") do
    json_request(method, url, body, authorization_header(auth, @user_agent))
  end

  defp json_request(method, url, body \\ "", headers \\ [], options \\ []) do
    request!(method, url, JSX.encode!(body), headers, options) |> process_response
  end
end
