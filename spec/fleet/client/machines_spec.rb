require 'spec_helper'

describe Fleet::Client::Machines do

  subject { Fleet::Client.new }

  let(:response) { double(:response) }

  describe '#list_machines' do

    before do
      allow(subject).to receive(:get).and_return(response)
    end

    it 'GETs the Fleet machines key' do
      expect(subject).to receive(:get)
        .with('fleet/v1/machines')
        .and_return(response)

      subject.list_machines
    end

    it 'returns the job response' do
      expect(subject.list_machines).to eql(response)
    end
  end
end
