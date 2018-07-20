# frozen_string_literal: true

class Journey
  MINIMUM_FARE = 1
  PENALTY = 9

  attr_reader :fare, :entry_station, :exit_station

  def initialize(entry_station = "TBC")
    @entry_station = entry_station
    @complete = !entry_station
  end

  def finish(station)
    @exit_station = station
    @complete = true
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY
  end

  def complete?
    @complete
  end
end
