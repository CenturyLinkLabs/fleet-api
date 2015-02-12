require 'spec_helper'

describe Fleet::Client::Unit do

  subject { Fleet::Client.new }

  let(:response) { double(:response) }

  describe '#list_units' do

    before do
      allow(subject).to receive(:get).and_return(response)
    end

    it 'GETs all Fleet units' do
      expect(subject).to receive(:get)
        .with("fleet/v1/units")
        .and_return(response)

      subject.list_units
    end

    it 'returns the unit response' do
      expect(subject.list_units).to eql(response)
    end
  end

  describe '#get_unit' do

    let(:name) { 'foo.service' }

    before do
      allow(subject).to receive(:get).and_return(response)
    end

    it 'GETs the Fleet unit' do
      expect(subject).to receive(:get)
        .with("fleet/v1/units/#{name}")
        .and_return(response)

      subject.get_unit(name)
    end

    it 'returns the unit response' do
      expect(subject.get_unit(name)).to eql(response)
    end
  end

  describe '#create_unit' do

    let(:name) { 'foo.service' }
    let(:options) { { exec_start: '/bin/bash' } }

    before do
      allow(subject).to receive(:put).and_return(response)
    end

    it 'PUTs the unit def to the Fleet unit key' do
      expect(subject).to receive(:put)
        .with("fleet/v1/units/#{name}", options)
        .and_return(response)

      subject.create_unit(name, options)
    end

    it 'returns the unit response' do
      expect(subject.create_unit(name, options)).to eql(response)
    end
  end

  describe '#delete_unit' do

    let(:name) { 'foo.service' }

    before do
      allow(subject).to receive(:delete).and_return(response)
    end

    it 'DELETEs the named Fleet unit' do
      expect(subject).to receive(:delete)
        .with("fleet/v1/units/#{name}")
        .and_return(response)

      subject.delete_unit(name)
    end

    it 'returns the job response' do
      expect(subject.delete_unit(name)).to eql(response)
    end
  end
end
