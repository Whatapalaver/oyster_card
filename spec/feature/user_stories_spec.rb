require_relative '../../lib/oystercard.rb'
describe 'user stories' do
    let(:oystercard) {Oystercard.new}

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

    describe 'user story 4' do
    # In order to pay for my journey
    # As a customer
    # I need my fare deducted from my card
        it 'deducts fares from balance' do
            oystercard.top_up(20)
            oystercard.deduct(5)
            expect(oystercard.balance).to eq(15)
        end
    end

    describe 'user story 5' do
    # In order to get through the barriers.
    # As a customer
    # I need to touch in and out.

    
    end

end