defmodule Grexst.Client do
  use GenServer
  use HTTPoison.Base
  require IEx

  @name GC
  @endpoint "https://api.github.com/gists?page="
  @user_agent [{"User-agent", "grexst"}]

  defmodule State do
    defstruct access_token: nil, last_page_num: nil
  end

  ## API
  def start_link(access_token \\ nil) do
    GenServer.start_link(__MODULE__, access_token, name: GC)
  end

  def get_gists(page \\ 1) do
    GenServer.call(@name, {:page, page})
  end

  def total_pages_of_gists do
    GenServer.call(@name, :total_pages)
  end

  def state do
    GenServer.call(@name, :state)
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks
  def init(access_token) do
    {:ok, %State{access_token: (access_token || System.get_env("GREXST_TOKEN"))}}
  end

  def handle_call(:total_pages, _from, %State{last_page_num: nil} = state) do
    {:ok, last_page, _body} = make_request(url(@endpoint, 1), authorization_header(state, []))
    {:reply, last_page, state}
  end

  def handle_call(:total_pages, _from, state) do
    {:reply, state.last_page_num, state}
  end

  def handle_call({:page, page}, _from, state) do
    {:ok, last_page, _body} = make_request(url(@endpoint, page), authorization_header(state, []))
    new_state = %State{state | last_page_num: last_page}
    {:reply, new_state, new_state}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  defp url(endpoint, page) when is_bitstring(page), do: endpoint <> page
  defp url(endpoint, page) when is_integer(page), do: endpoint <> Integer.to_string(page)

  defp make_request(url, headers) do
    request!(:get, url, "", headers, []) |> process_response
  end

  defp authorization_header(%{access_token: token}, headers) do
    headers ++ [{"Authorization", "token #{token}"}]
  end

  defp process_response(response) do
    _status_code = response.status_code #to be used for error handling later
    body         = response.body
    last_page    = extract_last_num_from_headers(response)
    {:ok, last_page, body}
  end

  def extract_last_num_from_headers(response) do
    {"Link", first_and_last} = Enum.find(response.headers, fn({k, _v}) -> k == "Link" end)
    last_url = String.split(first_and_last, ",")
    |> List.last
    |> String.split(";")
    |> List.first
    |> String.trim
    |> String.replace(~r/(<|>)/, "")

    @endpoint <> int_as_string = last_url
    {num, _} = Integer.parse(int_as_string)
    num
  end
end
