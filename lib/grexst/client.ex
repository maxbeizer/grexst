defmodule Grexst.Client do
  use HTTPoison.Base
  defstruct auth: nil, endpoint: "https://api.github.com/gists"
  @user_agent [{"User-agent", "grexst"}]

  def new(auth), do: %__MODULE__{auth: auth}

  def get_gists(client, page \\ 1) do
    url = url(client.endpoint, page)
    request(:get, url, client.auth)
  end

  defp process_response(response) do
    status_code = response.status_code
    body        = response.body

    response = unless body == "", do: body |> JSX.decode!,
    else: nil

    # if (status_code == 200), do: response,
    # else: {status_code, response}
    {status_code, response}
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
