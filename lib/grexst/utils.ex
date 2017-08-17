defmodule Grexst.Utils do
  def extract_gist_info([]), do: []

  def extract_gist_info([hd | tail]) do
    extract_gist_info(tail, build_gist_tuple_in_list(hd))
  end

  def extract_gist_info([], pull_urls), do: pull_urls

  def extract_gist_info([hd | tail], pull_urls) do
    extract_gist_info(tail, pull_urls ++ build_gist_tuple_in_list(hd))
  end

  defp build_gist_tuple_in_list(%{"git_pull_url" => git_pull_url, "id" => id}) do
    [{id, git_pull_url}]
  end
end
