# frozen_string_literal: true

require_relative '../../lib/oystercard.rb'
require_relative '../../lib/journey.rb'
describe 'user stories' do
  let(:oystercard) { Oystercard.new }
  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:station) { double :station }
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
      expect { oystercard.top_up(max_balance - 19) }.to raise_error "Cannot top_up: Maximum balance of #{max_balance} would be exceeded"
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
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end
    it 'allows me to touch out and not be in journey' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end
  end

  describe 'user story 6' do
    # In order to pay for my journey
    # As a customer
    # I need to have the minimum amount (£1) for a single journey.

    it 'on touch in it tests balance for minimum fare value' do
      expect { oystercard.touch_in(entry_station) }.to raise_error "Touch in failed: Minimum fare of at least #{Journey::MINIMUM_FARE} required"
    end
  end

  describe 'user story 7' do
    # In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
    it 'deducts minumum fare from balance' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -Journey::MINIMUM_FARE
    end
  end

  describe 'user story 8' do
    # In order to pay for my journey
    # As a customer
    # I need to know where I've travelled from
    it 'returns the entry station' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq(entry_station)
    end
  end

  describe 'user story 9' do
    # In order to know where I have been
    # As a customer
    # I want to see all my previous trips
    it 'returns a list of journeys including the latest journey' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      oystercard.touch_in('Aldgate')
      oystercard.touch_out('Shoreditch')
      expected_hash = { entry_station: 'Aldgate', exit_station: 'Shoreditch' }
      expected_array = []
      expected_array << expected_hash
      expect(oystercard.journeys).to eq(expected_array)
    end
  end

  describe 'user story 10' do
    # In order to know how far I have travelled
    # As a customer
    # I want to know what zone a station is in
    it 'returns the zone of a specific station' do
      shoreditch = Station.new('Shoreditch', 1)
      expect(shoreditch.zone).to eq(1)
    end
  end

  describe 'user story 11' do
    # In order to be charged correctly
    # As a customer
    # I need a penalty charge deducted if I fail to touch in or out

    it 'reduces balance by penalty amount if journey completed without touch out' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_in(entry_station) }.to change { oystercard.balance }.by -Journey::PENALTY
    end
    it 'reduces balance by penalty amount if journey completed without touch in' do
      oystercard.top_up(Oystercard::MAXIMUM_BALANCE)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by -Journey::PENALTY
    end
  end
end
