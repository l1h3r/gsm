defmodule GSM do
  @moduledoc """
  Documentation for GSM.
  """
  defmodule BadCharacter do
    defexception [:message]

    def exception(value) do
      %__MODULE__{
        message: "Unsupported GSM-7 character: #{inspect(value)}"
      }
    end
  end

  # Extended (2-byte) GSM-7 characters
  @extended GSM.Conversion.extended()

  # UTF-8 to GSM-7 character mapping
  @u2g GSM.Conversion.conversion()

  # GSM-7 to UTF-8 character mapping
  @g2t for {key, value} <- @u2g, into: %{}, do: {value, key}

  # GSM-7 escape character
  @escape "\x1B"

  # The version of the GSM-7 character set
  @version "03.38"

  @spec version :: binary
  def version, do: @version

  @doc """
  Convert the given binary from UTF-8 to GSM-7
  """
  @spec to_gsm(binary) :: binary
  def to_gsm(unicode) do
    unicode
    |> String.codepoints()
    |> Enum.reduce("", &(&2 <> gsm_char(&1)))
  end

  @doc """
  Convert the given binary from GSM-7 to UTF-8
  """
  @spec to_utf8(binary) :: binary
  def to_utf8(gsm) do
    gsm
    |> String.codepoints()
    |> Enum.reduce({"", false}, fn
      @escape, {acc, false} ->
        {acc, true}

      char, {acc, true} ->
        {acc <> utf8_char(@escape <> char), false}

      char, {acc, escape} ->
        {acc <> utf8_char(char), escape}
    end)
    |> elem(0)
  end

  @doc """
  Checks if the given UTF-8 string can be converted to GSM-7
  """
  @spec valid?(binary) :: boolean
  def valid?(unicode) do
    unicode
    |> String.codepoints()
    |> Enum.find(&(gsm_char?(&1) == false))
    |> is_nil()
  end

  @doc """
  Returns the number of characters required to send the given text via SMS
  """
  @spec size(binary, atom) :: integer
  def size(_, _ \\ :gsm)

  def size(text, :unicode) do
    text
    |> String.codepoints()
    |> Enum.count()
  end

  def size(text, :gsm) do
    text
    |> String.codepoints()
    |> Enum.count(&double?/1)
    |> Kernel.+(size(text, :unicode))
  end

  @doc """
  Checks if the given character is a 2-byte GSM-7 character
  """
  @spec double?(binary) :: boolean
  def double?(<<char::utf8>>), do: Map.has_key?(@extended, char)
  def double?(_), do: false

  # ======= #
  # Private #
  # ======= #

  @spec gsm_char?(binary) :: boolean
  defp gsm_char?(<<char::utf8>>), do: Map.has_key?(@u2g, char)
  defp gsm_char?(_), do: false

  @spec gsm_char(binary) :: binary | no_return
  defp gsm_char(<<char::utf8>>), do: get_char(char, @u2g)
  defp gsm_char(char), do: handle_invalid(char)

  @spec utf8_char(binary) :: binary | no_return
  defp utf8_char(char), do: char |> get_char(@g2t) |> char_to_utf8()

  @spec get_char(binary | integer, map) :: binary | no_return
  defp get_char(char, map), do: Map.get_lazy(map, char, fn -> handle_invalid(char) end)

  @spec handle_invalid(binary | integer) :: binary | no_return
  defp handle_invalid(char), do: handle_invalid(char, raise_invalid?())

  @spec handle_invalid(binary | integer, boolean) :: binary | no_return
  defp handle_invalid(char, true), do: raise(BadCharacter, char_to_utf8(char))
  defp handle_invalid(_, _), do: ""

  @spec char_to_utf8(binary | integer) :: binary
  defp char_to_utf8(char) when is_integer(char), do: <<char::utf8>>
  defp char_to_utf8(char), do: char

  @spec raise_invalid? :: boolean
  defp raise_invalid?, do: Application.get_env(:gsm, :raise_invalid, true)
end
