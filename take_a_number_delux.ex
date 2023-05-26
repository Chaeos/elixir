defmodule TakeANumberDeluxe do
  use GenServer
  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg), do: GenServer.start_link(TakeANumberDeluxe, init_arg)

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine), do: GenServer.call(machine, :report_state)

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine), do: GenServer.call(machine, :queue_new_number)

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil), do: GenServer.call(machine, {:serve_next_queued_number, priority_number})

  @spec reset_state(pid()) :: :ok
  def reset_state(machine), do: GenServer.cast(machine, :reset_state)

  # Server callbacks

  @impl GenServer
  def init(init_arg) do

    min_number = Keyword.get(init_arg, :min_number)
    max_number = Keyword.get(init_arg, :max_number)

    auto_shutdown_timeout = Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)

    case TakeANumberDeluxe.State.new(min_number, max_number, auto_shutdown_timeout) do
      {:ok, state} -> {:ok, state, auto_shutdown_timeout}
      {:error, error} -> {:stop, error}
    end

  end

  def handle_call(:report_state, _, state) do
    {:reply, state, state, state.auto_shutdown_timeout}
  end

  def handle_call(:queue_new_number, _, state) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} -> {:reply, {:ok, new_number}, new_state, state.auto_shutdown_timeout}
      {:error, message} -> {:reply, {:error, message}, state, state.auto_shutdown_timeout}
    end
  end

  def handle_call({:serve_next_queued_number, priority_number}, _, state) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, next_queued_number, new_state} -> {:reply, {:ok, next_queued_number}, new_state, state.auto_shutdown_timeout}
      {:error, message} -> {:reply, {:error, message}, state, state.auto_shutdown_timeout}
    end
  end

  def handle_cast(:reset_state, state) do
    {:ok, new_state} = TakeANumberDeluxe.State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)
    {:noreply, new_state, state.auto_shutdown_timeout }
  end

  def handle_info(message, state) do
    case message do
      :timeout -> {:stop, :normal, state}
      _ -> {:noreply, state, state.auto_shutdown_timeout}
    end
  end
end
