require 'spec_helper'

describe Fleet::ServiceDefinition do

  let(:name) { 'myservice.service' }

  let(:service_hash) do
    {
      'Unit' => {
        'Description' => 'infinite loop'
      },
      'Service' => {
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
ExecStart=#{service_hash['Service']['ExecStart']}
UNIT_FILE

      expected = {
        'Contents' => {
          'Unit' => {
            'Description' => [service_hash['Unit']['Description']]
          },
          'Service' => {
            'ExecStart' => [service_hash['Service']['ExecStart']]
          }
        },
        'Raw' => raw
      }

      expect(subject.to_unit).to eq expected
    end
  end

  describe '#to_job' do

    subject { described_class.new(name, service_hash) }

    it 'generates the appropriate job definition' do

      expected = {
        'Name' => name,
        'UnitHash' => [111, 150, 87, 109, 217, 26, 190, 221, 31, 28, 8, 211, 198, 126, 76, 157, 106, 164, 220, 134]
      }

      expect(subject.to_job).to eq expected
    end
  end

  describe '#sha1' do

    subject { described_class.new(name, service_hash) }

    it 'generates the appropriate sha1 hash' do
      expect(subject.sha1).to eq '6f96576dd91abedd1f1c08d3c67e4c9d6aa4dc86'
    end
  end
end
