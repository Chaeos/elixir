defmodule RemoteControlCar do

  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new() do
    %RemoteControlCar{nickname: "none"}
  end

  def new(nickname) do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{} = remote_car) do
    to_string(remote_car.distance_driven_in_meters) <> " meters"
  end

  def display_battery(%RemoteControlCar{} = remote_car) do
    battery = remote_car.battery_percentage
    if battery == 0, do: "Battery empty", else: "Battery at " <> to_string(battery) <> "%"
  end

  def drive(%RemoteControlCar{} = remote_car) do
    if remote_car.battery_percentage > 0 do
      %{remote_car |
        battery_percentage: remote_car.battery_percentage - 1,
        distance_driven_in_meters: remote_car.distance_driven_in_meters + 20
      }
    else
      remote_car
    end
  end
end
