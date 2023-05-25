defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part(ast, acc) do
    case ast do
      {:def, _, args} -> {ast, decode_last_part(args, acc)}
      {:defp, _, args} -> {ast, decode_last_part(args, acc)}
      _ -> {ast, acc}
    end
  end

  defp decode_last_part(ast, acc) do
    case ast do
      [func | _] ->
        decode_last_part(func, acc)
      {:when, _, args} ->
        decode_last_part(args, acc)
      {name, _, args} ->
        strname = Atom.to_string(name)
        [String.slice(strname, 0, length(args || [])) | acc]
      _ ->
        acc
    end
  end

  def decode_secret_message(string) do
    {_,acc} = Macro.prewalk(to_ast(string),[], &decode_secret_message_part/2)
    Enum.join(Enum.reverse(acc))
  end
end
