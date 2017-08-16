defmodule Grexst.Utils do
  def extract_gist_urls([]), do: []

  def extract_gist_urls([hd | tail]) do
    raw_urls = hd["files"] |> raw_urls_from_files_map()

    extract_gist_urls(tail, raw_urls)
  end

  def extract_gist_urls([], raw_urls), do: raw_urls

  def extract_gist_urls([hd | tail], raw_urls) do
    new_raw_urls = hd["files"] |> raw_urls_from_files_map()

    extract_gist_urls(tail, raw_urls ++ new_raw_urls)
  end

  defp raw_urls_from_files_map(files_map) do
    files_map |> Enum.map(fn {_, value} -> value["raw_url"] end)
  end
end
