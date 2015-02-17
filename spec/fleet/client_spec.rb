require 'spec_helper'

require 'fleet/service_definition'

describe Fleet::Client do

  describe '#initialize' do

    after do
      Fleet.reset
    end

    Fleet::Configuration::VALID_OPTIONS_KEYS.each do |option|
      it "inherits default #{option} value from Panamax" do
        client = Fleet::Client.new
        expect(client.send(option)).to eql(Fleet.send(option))
      end

      it "overrides default for #{option} when specified" do
        client = Fleet::Client.new(option => :foo)
        expect(client.send(option)).to eql(:foo)
      end
    end
  end

  describe '#list' do

    let(:machine_list) do
      {
        'machines' => [
          { 'id' => '123', 'primaryIP' => '1.1.1.1' }
        ]
      }
    end

    let(:state_list) do
      {
        'states' => [
          {
            'hash' => 'abc123',
            'machineID' => '123',
            'name' => 'foo.service',
            'systemdActiveState' => 'b',
            'systemdLoadState' => 'a',
            'systemdSubState' => 'c'
          }
        ]
      }
    end

    before do
      allow(subject).to receive(:list_machines).and_return(machine_list)
      allow(subject).to receive(:list_states).and_return(state_list)
    end

    it 'looks-up the list of machines' do
        expect(subject).to receive(:list_machines)
        subject.list
    end

    it 'looks-up the list of job states' do
        expect(subject).to receive(:list_states)
        subject.list
    end

    it 'returns the list of units' do
      expected = [{
        name: 'foo.service',
        load_state: 'a',
        active_state: 'b',
        sub_state: 'c',
        machine_id: '123',
        machine_ip: '1.1.1.1'
      }]

      expect(subject.list).to eq(expected)
    end
  end

  describe '#load' do

    let(:name) { 'foo.service' }
    let(:service_def) { { 'Unit' => { 'Description' => 'bar' } } }
    let(:sd) { Fleet::ServiceDefinition.new(service_def) }
    let(:response) { double(:response) }

    context 'when a service definition is provided' do
      before do
        allow(subject).to receive(:create_unit).and_return(response)
        allow(Fleet::ServiceDefinition).to receive(:new).and_return(sd)
      end

      it 'invokes #create_unit' do
        expect(subject).to receive(:create_unit)
          .with(name, sd.to_unit(name))

        subject.load(name, service_def)
      end

      it 'returns the #create_unit response' do
        r = subject.load(name, service_def)
        expect(r).to eq response
      end

      context 'when #create_unit raises PreconditionFailed' do

        before do
          allow(subject).to receive(:create_unit)
            .and_raise(Fleet::PreconditionFailed.new('boom'))
        end

        it 'does not blow up' do
          expect { subject.load(name, service_def) }.to_not raise_error
        end
      end

      context 'when #create_unit raises something other than PreconditionFailed' do

        before do
          allow(subject).to receive(:create_unit)
            .and_raise(Fleet::BadRequest.new('boom'))
        end

        it 'propagates the error' do
          expect { subject.load(name, service_def) }.to(raise_error(Fleet::BadRequest))
        end
      end
    end

    context 'when no service definition is provided' do

      before do
        allow(subject).to receive(:update_unit).and_return(response)
      end

      it 'does NOT invoke #create_unit' do
        expect(subject).to_not receive(:create_unit)
        subject.load(name)
      end

      it 'invokes #update' do
        expect(subject).to receive(:update_unit)
          .with(name, { 'desiredState' => 'loaded', 'name' => name })

        subject.load(name)
      end
    end

    context 'when the supplied name is invalid' do

      let(:name) { 'foo!.service' }

      it 'raises an ArgumentError' do
        expect { subject.load(name, nil) }.to raise_error(ArgumentError, /only contain/)
      end
    end
  end

  describe '#start' do
    let(:service_name) { 'foo.service' }

    before do
      allow(subject).to receive(:update_unit).and_return(nil)
    end

    it 'invokes #update_unit' do
      expect(subject).to receive(:update_unit)
        .with(service_name, { 'desiredState' => 'launched', 'name' => service_name })

      subject.start(service_name)
    end
  end

  describe '#stop' do
    let(:service_name) { 'foo.service' }

    before do
      allow(subject).to receive(:update_unit).and_return(nil)
    end

    it 'invokes #update_unit' do
      expect(subject).to receive(:update_unit)
        .with(service_name, { 'desiredState' => 'loaded', 'name' => service_name })

      subject.stop(service_name)
    end
  end

  describe '#unload' do
    let(:service_name) { 'foo.service' }

    before do
      allow(subject).to receive(:update_unit).and_return(nil)
    end

    it 'invokes #update_unit' do
      expect(subject).to receive(:update_unit)
        .with(service_name, { 'desiredState' => 'inactive', 'name' => service_name })

      subject.unload(service_name)
    end
  end

  describe '#destroy' do
    let(:service_name) { 'foo.service' }

    before do
      allow(subject).to receive(:delete_unit).and_return(nil)
    end

    it 'invokes #delete_job' do

      expect(subject).to receive(:delete_unit)
                         .with(service_name)
                         .and_return(nil)

      subject.destroy(service_name)
    end
  end

  describe '#status' do

    let(:service_name) { 'foo.service' }

    let(:fleet_state) do
      { 'currentState' => 'launched' }
    end

    before do
      allow(subject).to receive(:get_unit).and_return(fleet_state)
    end

    it 'retrieves service state from the fleet client' do
      expect(subject).to receive(:get_unit).with(service_name)
      subject.status(service_name)
    end

    it 'returns the symbolized state' do
      expect(subject.status(service_name)).to eq(:launched)
    end
  end

  describe '#get_unit_state' do

    let(:service_name) { 'foo.service' }

    let(:states) do
      { 'states' => [] }
    end

    before do
      allow(subject).to receive(:list_states).and_return(states)
    end

    it 'retrieves the states from the fleet API' do
      expect(subject).to receive(:list_states).with({ unitName: service_name })
      subject.get_unit_state(service_name)
    end

    context 'when unit is found' do

      let(:states) do
        { 'states' => [{ 'name' => 'foo.service' }, {}] }
      end

      it 'returns the first matching state hash' do
        expect(subject.get_unit_state(service_name)).to eq(states['states'].first)
      end
    end

    context 'when unit is NOT found' do

      let(:states) { {} }

      it 'returns the first matching state hash' do
        expect { subject.get_unit_state(service_name) }.to(
          raise_error(Fleet::NotFound))
      end
    end
  end
end
