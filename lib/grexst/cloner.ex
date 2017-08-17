defmodule Grexst.Cloner do
  @doc"""
  Uses the git_cli to clone a gist_git_url, and uses the id to create a distinct
  folder in the tmp dir. Returns the path of the of the cloned directory.
  """
  def clone({id, gist_git_url}) do
    case Git.clone [gist_git_url, tmp_dir(id)] do
      {:ok, repo}   -> repo.path
      {:error, err} ->
        [_gist_raw_url, path] = err.args
        path
    end
  end

  def tmp_dir(id), do: System.tmp_dir() <> "/#{id}"
end
