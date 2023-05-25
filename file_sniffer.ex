defmodule FileSniffer do
  def type_from_extension(extension) do
    case extension do
      "exe"	-> "application/octet-stream"
      "bmp"	-> "image/bmp"
      "png"	-> "image/png"
      "jpg"	-> "image/jpg"
      "gif"	-> "image/gif"
      _ -> nil
    end
  end

  def type_from_binary(file) do
    cond do
      String.starts_with?(file, <<0x7F, 0x45, 0x4C, 0x46>>) -> "application/octet-stream"
      String.starts_with?(file, <<0x42, 0x4D>>) -> "image/bmp"
      String.starts_with?(file, <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>) -> "image/png"
      String.starts_with?(file, <<0xFF, 0xD8, 0xFF>>) -> "image/jpg"
      String.starts_with?(file, <<0x47, 0x49, 0x46>>) -> "image/gif"
      true -> nil
    end
  end

  def verify(file, extension) do

    if type_from_extension(extension) == type_from_binary(file), do: {:ok, type_from_binary(file)}, else: {:error, "Warning, file format and file extension do not match."}
  end
end
