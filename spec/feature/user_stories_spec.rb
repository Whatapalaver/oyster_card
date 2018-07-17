require_relative '../../lib/oystercard.rb'
describe 'user stories' do
    let(:oystercard) {Oystercard.new}
    let(:station){ double :station }

    describe 'user story 1' do
    # In order to use public transport
    # As a customer
    # I want money on my card
        it 'returns a balance of zero' do
            expect(oystercard.balance).to eq(0)
        end
    end

    describe 'user story 2' do
    # In order to keep using public transport
    # As a customer
    # I want to add money to my card
        it 'allows money to be added to card' do
            oystercard.top_up(20)
            expect(oystercard.balance).to eq(20)
        end
    end

    describe 'user story 3' do
    # In order to protect my money from theft or loss
    # As a customer
    # I want a maximum limit (of £90) on my card
        it 'prevents deposit above maximum limit' do
            max_balance = Oystercard::MAXIMUM_BALANCE
            oystercard.top_up(20)
            expect {oystercard.top_up(max_balance - 19) }.to raise_error "Cannot top_up: Maximum balance of #{max_balance} would be exceeded"
        end
    end

    # Superceded by later test and deduct now private
    # describe 'user story 4' do
    # # In order to pay for my journey
    # # As a customer
    # # I need my fare deducted from my card
    #     it 'deducts fares from balance' do
    #         oystercard.top_up(20)
    #         oystercard.deduct(5)
    #         expect(oystercard.balance).to eq(15)
    #     end
    # end

    describe 'user story 5' do
    # In order to get through the barriers.
    # As a customer
    # I need to touch in and out.

        it 'allows me to touch in and be in journey' do
            oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
            oystercard.touch_in(station)
            expect(oystercard).to be_in_journey
        end
        it 'allows me to touch out and not be in journey' do
            oystercard.touch_out
            expect(oystercard).not_to be_in_journey
        end
    end

    describe 'user story 6' do
    # In order to pay for my journey
    # As a customer
    # I need to have the minimum amount (£1) for a single journey.

        it 'on touch in it tests balance for minimum fare value' do
            expect { oystercard.touch_in(station) }.to raise_error "Touch in failed: Minimum fare of at least #{Oystercard::MINIMUM_FARE} required"
        end
    end

    describe 'user story 7' do
    # In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
        it 'deducts minumum fare from balance' do
            oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
            oystercard.touch_in(station) 
            expect { oystercard.touch_out }.to change{oystercard.balance}.by (-Oystercard::MINIMUM_FARE)
        end
    end

    describe 'user story 8' do
    # In order to pay for my journey
    # As a customer
    # I need to know where I've travelled from
        it 'returns the entry station' do
            oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
            oystercard.touch_in(station)
            expect(oystercard.entry_station).to eq(station)
        end
    end
end