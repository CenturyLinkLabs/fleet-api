require 'spec_helper'

describe Fleet::Client::Unit do

  subject { Fleet::Client.new }

  let(:response) { double(:response) }

  describe '#list_units' do

    before do
      allow(subject).to receive(:get).and_return(response)
    end

    it 'GETs the Fleet unit key' do
      expect(subject).to receive(:get)
        .with("v2/keys/_coreos.com/fleet/unit")
        .and_return(response)

      subject.list_units
    end

    it 'returns the job response' do
      expect(subject.list_units).to eql(response)
    end
  end

  describe '#create_unit' do

    let(:sha) { '33ef9ba9029c' }
    let(:unit_def) { { exec_start: '/bin/bash' } }

    before do
      allow(subject).to receive(:put).and_return(response)
    end

    it 'PUTs the unit def to the Fleet unit key' do
      opts = {
        querystring: { 'prevExist' => false },
        body: { value: unit_def.to_json }
      }

      expect(subject).to receive(:put)
        .with("v2/keys/_coreos.com/fleet/unit/#{sha}", opts)
        .and_return(response)

      subject.create_unit(sha, unit_def)
    end

    it 'returns the job response' do
      expect(subject.create_unit(sha, unit_def)).to eql(response)
    end
  end

  describe '#delete_unit' do

    let(:sha) { '33ef9ba9029c' }

    before do
      allow(subject).to receive(:delete).and_return(response)
    end

    it 'DELETEs the named Fleet unit key' do
      opts = { dir: false, recursive: false }
      expect(subject).to receive(:delete)
        .with("v2/keys/_coreos.com/fleet/unit/#{sha}", opts)
        .and_return(response)

      subject.delete_unit(sha)
    end

    it 'returns the job response' do
      expect(subject.delete_unit(sha)).to eql(response)
    end
  end
end
