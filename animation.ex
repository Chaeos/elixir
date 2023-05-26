defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts) :: {:ok, opts} | {:error, error}
  @callback handle_frame(dot,frame_number,opts) :: dot

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation
  @impl DancingDots.Animation
  def handle_frame(dot, frame_number, _) do
    case rem(frame_number, 4) do
       0 -> %{dot | opacity: dot.opacity * 0.5}
       _ -> dot
    end
  end
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation
  @impl DancingDots.Animation

  def init([velocity: v]) when is_number(v), do: {:ok, [{:velocity,v}]}

  def init(opts), do: {:error, "The :velocity option is required, and its value must be a number. Got: #{inspect(Keyword.get(opts, :velocity))}"}

  def handle_frame(dot, frame_number, opts), do: %{dot | radius: dot.radius + (frame_number - 1) * Keyword.get(opts, :velocity)}
end
