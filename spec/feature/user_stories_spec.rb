describe 'user stories' do
    describe 'user story 1' do
        # In order to use public transport
        # As a customer
        # I want money on my card

        it 'returns a balance of zero' do
            new_card = Oystercard.new
            expect(new_card.balance).to eq(0)
        end
    end

end