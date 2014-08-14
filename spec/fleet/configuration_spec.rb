require 'spec_helper'
require 'fleet/configuration'

describe Fleet::Configuration do

  subject { Class.new { extend Fleet::Configuration } }

  describe 'exposed attribes' do
    Fleet::Configuration::VALID_OPTIONS_KEYS.each do |key|
      it { should respond_to key.to_sym }
    end
  end

  describe 'default values' do

    describe 'adapter' do
      it 'is matches DEFAULT_ADAPTER' do
        expect(subject.adapter).to eq Fleet::Configuration::DEFAULT_ADAPTER
      end
    end

    describe 'fleet_api_url' do
      it 'is matches DEFAULT_ETCD_API_URL' do
        expect(subject.fleet_api_url).to eq Fleet::Configuration::DEFAULT_ETCD_API_URL
      end
    end

    describe 'open_timeout' do
      it 'is matches DEFAULT_OPEN_TIMEOUT' do
        expect(subject.open_timeout).to eq Fleet::Configuration::DEFAULT_OPEN_TIMEOUT
      end
    end

    describe 'read_timeout' do
      it 'is matches DEFAULT_READ_TIMEOUT' do
        expect(subject.read_timeout).to eq Fleet::Configuration::DEFAULT_READ_TIMEOUT
      end
    end

    describe 'logger' do
      it 'is matches DEFAULT_LOGGER' do
        expect(subject.logger).to eq Fleet::Configuration::DEFAULT_LOGGER
      end
    end
  end
end
