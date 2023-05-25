defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    NaiveDateTime.to_time(datetime) < ~T[12:00:00]
  end

  def return_date(checkout_datetime) do
    data = if before_noon?(checkout_datetime), do: NaiveDateTime.add(checkout_datetime, 28, :day), else: NaiveDateTime.add(checkout_datetime, 29, :day)

    NaiveDateTime.to_date(data)
  end

  def days_late(planned_return_date, actual_return_datetime) do

    days = Date.diff(actual_return_datetime,planned_return_date)
    if days < 0, do: 0, else: days

  end

  def monday?(datetime) do
    Date.day_of_week(datetime) == 1
  end

  def calculate_late_fee(checkout, return, rate) do

    dcheckout = datetime_from_string(checkout)
    dreturn = datetime_from_string(return)
    rate = if monday?(dreturn), do: rate*0.5, else: rate

    diff = days_late(dcheckout,dreturn)
    days = if before_noon?(dcheckout), do: 28,else: 29

    if diff > days, do: trunc((diff-days)*rate), else: 0
  end
end
