defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, & &1.price)
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &(&1.price == nil))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn x ->
      %{ x | name: String.replace(x.name,old_word,new_word) }
    end)
  end

  def increase_quantity(item, count) do
    quant = Map.new(item.quantity_by_size, fn {k,v} ->
      {k, v + count}
    end)

    %{ item | quantity_by_size: quant }
  end

  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_,v}, acc ->
      v + acc
    end)
  end
end
