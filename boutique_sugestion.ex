defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    price = Keyword.get(options, :maximum_price, 100)
    for x <- tops, y <- bottoms, x.base_color != y.base_color and x.price + y.price <= price do
      {x, y}
    end
  end
end
