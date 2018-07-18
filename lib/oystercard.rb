require_relative 'station'
class Oystercard
    MAXIMUM_BALANCE = 90
    MINIMUM_FARE = 1
    PENALTY = 9
    attr_reader :balance, :journeys, :entry_station, :exit_station
   
    def initialize
        @balance = 0   
        @journeys = []
    end

    def top_up(amount)
        @amount = amount
        raise "Cannot top_up: Maximum balance of #{MAXIMUM_BALANCE} would be exceeded" if exceeds_limit?
        @balance += amount
    end

    def touch_in(station)
        raise "Touch in failed: Minimum fare of at least #{MINIMUM_FARE} required" unless minimum_fare_balance?
        @entry_station = station
        deduct(PENALTY) if not_touched_out(journeys)
        journeys << {entry_station: station, exit_station: nil}
    end

    def touch_out(station)
        @exit_station = station
        if not_touched_in(journeys)
            journeys << { entry_station: nil, exit_station: exit_station }
            deduct(PENALTY)
        else
            deduct(MINIMUM_FARE)
            journeys.last[:exit_station] = station
        end
        @entry_station = nil
        @exit_station
    end

    def in_journey?
        !!entry_station
    end

    private

    def deduct(fare)
        @balance -= fare
    end

    def exceeds_limit?
        @balance + @amount > MAXIMUM_BALANCE
    end

    def minimum_fare_balance?
        @balance >= MINIMUM_FARE
    end

    def not_touched_in(journeys)
        journeys.empty? || journeys.last[:exit_station] != nil
    end
    
    def not_touched_out(journeys)
        !journeys.empty? && journeys.last[:exit_station] == nil
    end
end