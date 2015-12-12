defmodule Grexst.APIResponseParserTest do
  use ExUnit.Case
  doctest Grexst
  alias Grexst.APIResponseParser

  test "when only one file in result, parser returns the raw URLs" do
    res = [
      %{"files" =>
        %{"iex.md" =>
          %{"filename" => "iex.md", "language" => "Markdown", "raw_url" => "some_gist_url", "size" => 77, "type" => "text/plain" }
        }
      }
    ]
    assert APIResponseParser.parse(res) == ["some_gist_url"]
  end

  test "when more than one file in result, parser returns the raw URLs" do
    two_files = [
      %{
        "files" =>
        %{ "file_1.md" =>
          %{"filename" => "file_1.md", "language" =>
            "Markdown", "raw_url" => "gist_url_one", "size" => 11, "type" => "text/plain"
          }, "file_2.md" =>
          %{"filename" => "file_2.md",
            "language" => "Markdown", "raw_url" => "gist_url_two", "size" => 11, "type" => "text/plain"
          }
        }
      }
    ]
    assert APIResponseParser.parse(two_files) == ["gist_url_one", "gist_url_two"]
  end
end
