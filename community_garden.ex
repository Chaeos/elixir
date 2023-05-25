defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> {1,opts} end)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {_, plots} -> plots end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {id, plots} ->
      nplot = %Plot{plot_id: id, registered_to: register_to}
      {nplot,{id + 1, [nplot | plots]}}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn {id, plots} ->
      {
        id,
        Enum.filter(plots, fn fplot ->
         fplot.plot_id != plot_id
        end)
      }
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {id,plots} -> Enum.find(plots, {:not_found, "plot is unregistered"}, fn fplot -> fplot.plot_id == plot_id end) end)
  end
end
