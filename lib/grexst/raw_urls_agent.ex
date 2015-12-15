defmodule Grexst.RawURLsAgent do
  require IEx

  defp name, do: __MODULE__

  def start_link, do: Agent.start_link(fn -> [] end, name: name())

  def add_urls(urls), do: Agent.update(name, fn list -> list ++ urls end)

  def get_url do
    [head|tail] = Agent.get(name, fn list -> list end)
    Agent.update(name, fn list -> tail end)
    head
  end

  def clear_urls, do: Agent.update(name, fn _ -> [] end)
end
