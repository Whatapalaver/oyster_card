require 'oystercard'
describe Oystercard do
    subject(:oystercard) {described_class.new}
    describe '#initialize' do
        it 'has a balance of zero' do
            expect(oystercard.balance).to eq(0)
        end
    end
    describe '#top-up' do
       it 'can top_up balance' do
            expect { oystercard.top_up(20) }.to change{oystercard.balance}.by (20)
        end
        it 'prevents balance exceeding a max allowance' do
            max_balance = Oystercard::MAXIMUM_BALANCE
            oystercard.top_up(max_balance)
            expect { oystercard.top_up(1) }.to raise_error "Cannot top_up: Maximum balance of #{max_balance} would be exceeded"
        end
    end
    describe '#deduct' do
       it 'can reduce balance by value of fare' do
            expect { oystercard.deduct(5) }.to change{oystercard.balance}.by (-5)
        end
    end
end