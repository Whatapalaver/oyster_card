require 'oystercard'
describe Oystercard do

    subject(:oystercard) {described_class.new}
    let(:station){ double :station }

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
    
    describe 'touch_in' do
        context 'balance above minimum' do
            before do
                oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
            end
            it 'responds to touch_in' do
                expect(oystercard).to respond_to(:touch_in)
            end
            it 'changes in_journey? to true' do
                oystercard.touch_in(station)
                expect(oystercard).to be_in_journey
            end
            it 'returns the entry station' do
                oystercard.touch_in(station)
                expect(oystercard.entry_station).to eq station
            end
        end
        context 'balance below minimum' do
            it 'raises an error' do
                expect { oystercard.touch_in(station) }.to raise_error "Touch in failed: Minimum fare of at least #{Oystercard::MINIMUM_FARE} required"
            end
        end
    end
    describe 'touch_out' do
        context 'balance above minimum' do
            before do
                oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
            end
            it 'responds to touch_out' do
                expect(oystercard).to respond_to(:touch_out)
            end
            it 'changes in_journey? to false' do
                oystercard.touch_out
                expect(oystercard).not_to be_in_journey
            end
            it 'deducts minumum fare from balance' do
                oystercard.touch_in(station) 
                expect { oystercard.touch_out }.to change{oystercard.balance}.by (-Oystercard::MINIMUM_FARE)
            end
        end
    end
end