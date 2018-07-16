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
end