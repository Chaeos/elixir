defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    %{input: input, pid: spawn_link(fn -> calculator.(input) end)}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    res = receive do
      {:EXIT, ^pid, :normal} -> :ok
      {:EXIT, ^pid, _} -> :error
    after
      100 -> :timeout
    end

    Map.put(results, input, res)
  end

  def reliability_check(calculator, inputs) do
    flag = Process.flag(:trap_exit, true)

    res = Enum.map(inputs, fn x -> start_reliability_check(calculator, x) end)
    |> Enum.reduce(%{}, fn x,y -> await_reliability_check_result(x, y) end)

    Process.flag(:trap_exit, flag)
    res
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn x -> Task.async(fn -> calculator.(x) end) end)
    |> Enum.map(fn x -> Task.await(x,100) end)
  end
end
