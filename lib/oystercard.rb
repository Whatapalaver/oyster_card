class Oystercard
    MAXIMUM_BALANCE = 90
    MINIMUM_FARE = 1
    attr_reader :balance

    def initialize
        @balance = 0 
        @in_journey = false   
    end

    def top_up(amount)
        @amount = amount
        raise "Cannot top_up: Maximum balance of #{MAXIMUM_BALANCE} would be exceeded" if exceeds_limit?
        @balance += amount
    end
    
    def deduct(fare)
        @balance -= fare
    end

    def exceeds_limit?
        @balance + @amount > MAXIMUM_BALANCE
    end

    def minimum_fare_balance?
        @balance >= MINIMUM_FARE
    end

    def touch_in
        raise 'Touch in failed: Minimum fare required' unless minimum_fare_balance?
        @in_journey = true
    end

    def touch_out
        @in_journey = false
    end

    def in_journey?
        @in_journey
    end
end