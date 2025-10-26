defmodule Support.NimbleTests do
  @moduledoc ~S"""
  Makes asserting on NimbleParsec results simpler
  """
  defmacro parsed_error(parsed, expected) do
    quote do
      # |> IO.inspect()
      {:error, message, _, _, _, _} = unquote(parsed)
      assert message == unquote(expected)
    end
  end

  defmacro parsed_ok(parsed, expected) do
    quote do
      {:ok, result, _, _, _, _} = unquote(parsed)
      assert result == unquote(expected)
    end
  end

  defmacro parsed_inspected(parsed, expected) do
    quote do
      result = unquote(parsed) |> IO.inspect(label: :parse_result)
      {:ok, result, _, _, _, _} = result
      assert result == unquote(expected)
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
