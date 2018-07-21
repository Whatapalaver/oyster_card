# frozen_string_literal: true

require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:min_fare) { Journey::MINIMUM_FARE }
  let(:journey) { { entry_station: entry_station, exit_station: exit_station } }

  describe '#initialize' do
    it 'has a balance of zero' do
      expect(oystercard.balance).to eq(0)
    end
  end
  describe '#top-up' do
    it 'can top_up balance' do
      expect { oystercard.top_up(20) }.to change { oystercard.balance }.by 20
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
      # it 'changes in_journey? to true' do
      #   oystercard.touch_in(entry_station)
      #   expect(oystercard).to be_in_journey
      # end
      it 'returns the entry station' do
        oystercard.touch_in(entry_station)
        expect(oystercard.entry_station).to eq entry_station
      end
    end
    context 'balance below minimum' do
      it 'raises an error' do
        expect { oystercard.touch_in(entry_station) }.to raise_error "Touch in failed: Minimum fare of at least #{min_fare} required"
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
      # it 'changes in_journey? to false' do
      #   oystercard.touch_in(entry_station)
      #   oystercard.touch_out(exit_station)
      #   expect(oystercard).not_to be_in_journey
      # end
      it 'deducts minumum fare from balance' do
        oystercard.touch_in(entry_station)
        expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -min_fare
      end
      it 'returns the exit station' do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.exit_station).to eq exit_station
      end
    end
  end
  describe '#journeys' do
    context 'balance above minimum' do
      before do
        oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      end
      it 'has an empty list of journeys by default' do
        expect(oystercard.journey_history).to be_empty
      end
      it 'stores a journey' do
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.journey_history).to include journey
      end
    end
  end
end
