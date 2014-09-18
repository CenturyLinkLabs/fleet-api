require 'spec_helper'

describe Fleet::ServiceDefinition do

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

  describe '#to_unit' do

    subject { described_class.new(service_hash) }

    it 'provides a fleet formatted unit definition' do

      expected = {
        "desiredState" =>"loaded", 
        "options"=> [
          { "section" => "Unit", "name" => "Description", "value" => "infinite loop"}, 
          {"section" => "Service", "name" => "ExecStart", "value" => "/bin/bash -c \"while true; do sleep 1; done\""}
        ]
      }

      expect(subject.to_unit).to eq expected
    end
  end
end
