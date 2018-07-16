class Oystercard
    MAXIMUM_BALANCE = 90
    attr_reader :balance

    def initialize
        @balance = 0    
    end

    def top_up(amt)
        raise "Cannot top_up: Maximum balance of #{MAXIMUM_BALANCE} would be exceeded" if (@balance + amt) > MAXIMUM_BALANCE
        @balance += amt
    end
    
    def deduct(fare)
        @balance -= fare
    end
end