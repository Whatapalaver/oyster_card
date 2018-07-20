require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:station)  { double :station, zone: 1 }

  it "knows if a journey is not complete" do
    expect(journey).not_to be_complete
  end

  # it 'has a penalty fare by default' do
  #   expect(journey.fare).to eq Journey::PENALTY_FARE
  # end

  # it "returns itself when exiting a journey" do
  #   expect(journey.finish(station)).to eq(journey)
  # end

  context 'given an entry station' do
    subject {described_class.new(station)}

    it 'has an entry station' do
      expect(subject.entry_station).to eq station
    end

    xit "returns a penalty fare if no exit station given" do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end

    context 'given an exit station' do
      let(:other_station) { double :other_station }

      before do
        subject.finish(other_station)
      end

      it 'calculates a fare' do
        expect(subject.fare).to eq Journey::MINIMUM_FARE
      end

      it "knows if a journey is complete" do
        expect(subject).to be_complete
      end
    end
  end
end