defmodule Grexst.Parser do
  def file_paths_from_cloned_gists(path) do
    Path.wildcard(path <> "/*")
  end

  def do_things(path) do
    path
    |> File.stream!
    |> Stream.take(10)
    |> Stream.map(&String.strip/1)
    |> Enum.each(&IO.inspect/1)
  end
end
