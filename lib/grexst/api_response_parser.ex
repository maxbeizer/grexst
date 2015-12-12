defmodule Grexst.APIResponseParser do
  # traverse the list of responses
  # extract the raw urls from each of the files
  def parse(response) do
    response
    |> Enum.flat_map(&get_raw_urls/1)
  end

  defp get_raw_urls(res) do
    for file <- res["files"] do
      {_name, info} = file
      info["raw_url"]
    end
  end
end
