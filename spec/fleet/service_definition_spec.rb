require 'spec_helper'

describe Fleet::ServiceDefinition do

  let(:name) { 'myservice.service' }

  let(:service_hash) do
    {
      'Unit' => {
        'Description' => 'infinite loop'
      },
      'Service' => {
        'ExecStartPre' => ['foo', 'bar'],
        'ExecStart' => "/bin/bash -c \"while true; do sleep 1; done\""
      }
    }
  end

  subject { described_class.new(name) }

  it { should respond_to :name }

  describe '#initialize' do

    subject { described_class.new(name) }

    describe 'name' do
      it 'should equal the passed-in name' do
        expect(subject.name).to eq name
      end
    end
  end

  describe '#to_unit' do

    subject { described_class.new(name, service_hash) }

    it 'provides a fleet formatted unit definition' do

      raw = <<UNIT_FILE
[Unit]
Description=#{service_hash['Unit']['Description']}

[Service]
ExecStartPre=#{service_hash['Service']['ExecStartPre'].first}
ExecStartPre=#{service_hash['Service']['ExecStartPre'].last}
ExecStart=#{service_hash['Service']['ExecStart']}
UNIT_FILE

      expected = { 'Raw' => raw }

      expect(subject.to_unit).to eq expected
    end
  end

  describe '#to_job' do

    subject { described_class.new(name, service_hash) }

    it 'generates the appropriate job definition' do

      expected = {
        'Name' => name,
        'UnitHash' => [173,163,19,156,23,184,6,223,77,240,208,230,238,54,179,201,80,147,228,89]
      }

      expect(subject.to_job).to eq expected
    end
  end

  describe '#sha1' do

    subject { described_class.new(name, service_hash) }

    it 'generates the appropriate sha1 hash' do
      expect(subject.sha1).to eq 'ada3139c17b806df4df0d0e6ee36b3c95093e459'
    end
  end
end
