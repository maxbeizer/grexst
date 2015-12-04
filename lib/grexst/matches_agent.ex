defmodule Grexst.MatchesAgent do

  defp name, do: __MODULE__

  def start_link, do: Agent.start_link(fn -> HashDict.new end, name: name())

  def get, do: Agent.get(name(), &(&1))

  def clear_matches, do: Agent.update(name, fn _ -> HashDict.new end)
end
