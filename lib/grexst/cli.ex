defmodule Grexst.CLI do
  def main() do
    System.argv |> parse_args |> process
  end

  defp parse_args(args) do
    parse = OptionParser.parse(args,
                               switches: [help: :boolean],
                               aliases: [h: :help])
    case parse do
      { [help: true], _, _     } -> :help
      { _, [term], _       }     -> {:grexst, term}
      _                          -> :help
    end
  end

  defp process(:help) do
    IO.puts """
    --------------------------
    --------------------------
    Usage: grexst "term regex"
    --------------------------
    --------------------------
    """
    System.halt(0)
  end

  defp process({:grexst, term}), do: Grexst.main(:stdio, term)

  defp process(_), do: process(:help)
end
