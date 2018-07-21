# frozen_string_literal: true

require_relative 'station'
require_relative 'journey'

class Oystercard
  MAXIMUM_BALANCE = 90

  attr_reader :balance, :journey_history, :entry_station,
              :exit_station, :journey

  def initialize
    @balance = 0
    @journey_history = []
  end

  def top_up(amount)
    @amount = amount
    raise "Cannot top_up: Maximum balance of #{MAXIMUM_BALANCE} would be exceeded" if exceeds_limit?
    @balance += amount
  end

  def touch_in(station)
    raise "Touch in failed: Minimum fare of at least #{Journey::MINIMUM_FARE} required" unless minimum_fare_balance?
    if in_journey?
      journey_history.last[:exit_station] = "Double touch-in: #{station}"
      clear_journey
    else
      @entry_station = station
      @journey = Journey.new(station)
      journey_history << { entry_station: station, exit_station: nil }
    end
  end

  def touch_out(station)
    @exit_station = station
    if !in_journey?
      @journey = Journey.new(station)
      journey_history << { entry_station: nil, exit_station: exit_station }
    else
      @journey.finish(station)
      journey_history.last[:exit_station] = station
    end
    clear_journey
    @exit_station
  end

  def in_journey?
    !!entry_station
  end

  private

  def clear_journey
    deduct(@journey.fare)
    @entry_station = nil
    @journey = nil
  end

  def deduct(fare)
    @balance -= fare
  end

  def exceeds_limit?
    @balance + @amount > MAXIMUM_BALANCE
  end

  def minimum_fare_balance?
    @balance >= Journey::MINIMUM_FARE
  end
end
