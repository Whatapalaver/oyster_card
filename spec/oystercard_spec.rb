require 'oystercard'
describe Oystercard do
    subject(:oystercard) {described_class.new}
    describe '#initialize' do
        it 'has a balance of zero' do
            expect(oystercard.balance).to eq(0)
        end
    end
    describe '#top-up' do
        it 'oystercard responds to top_up method' do
            expect(oystercard).to respond_to(:top_up).with(1).argument 
        end
        it 'can top_up balance' do
            expect { oystercard.top_up(20) }.to change{oystercard.balance}.by (20)
        end
        it 'prevents balance exceeding a max allowance' do
            max_balance = Oystercard::MAXIMUM_BALANCE
            oystercard.top_up(max_balance)
            expect { oystercard.top_up(1) }.to raise_error "Cannot top_up: Maximum balance of #{max_balance} would be exceeded"
        end
    end
end