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
    describe 'touch_in' do
        context 'balance above minimum' do
            before do
                oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
            end
            it 'responds to touch_in' do
                expect(oystercard).to respond_to(:touch_in)
            end
            it 'changes in_journey? to true' do
                oystercard.touch_in
                expect(oystercard).to be_in_journey
            end
        end
        context 'balance below minimum' do
            it 'raises an error' do
                expect { oystercard.touch_in }.to raise_error 'Touch in failed: Minimum fare required'
            end
        end
    end
    describe 'touch_out' do
        it 'responds to touch_out' do
            expect(oystercard).to respond_to(:touch_out)
        end
        it 'changes in_journey? to false' do
            oystercard.touch_out
            expect(oystercard).not_to be_in_journey
        end
    end
end