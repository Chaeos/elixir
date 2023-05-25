defmodule BasketballWebsite do

  def extract_from_path(data,""), do: data
  def extract_from_path(data, path) do
    [ h | t ] =  String.split(path,".")
    extract_from_path(data[h],Enum.join(t,"."))
  end

  def get_in_path(data, path) do
    get_in(data,String.split(path,"."))
  end
end
