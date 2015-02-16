require 'spec_helper'

describe Fleet::Client::Machines do

  subject { Fleet::Client.new }

  let(:response) { double(:response) }

  describe '#list_states' do

    before do
      allow(subject).to receive(:get).and_return(response)
    end

    it 'GETs the state resource' do
      expect(subject).to receive(:get)
        .with('fleet/v1/state', nil)
        .and_return(response)

      subject.list_states
    end

    it 'returns the state response' do
      expect(subject.list_states).to eql(response)
    end
  end
end
