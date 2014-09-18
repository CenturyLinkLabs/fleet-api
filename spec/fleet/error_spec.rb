require 'spec_helper'

describe Fleet::Error do

  let(:message) { 'some message' }
  let(:error_code) { 12345 }

  subject { Fleet::Error.new(message, error_code) }

  it { should respond_to(:message) }
  it { should respond_to(:error_code) }

  describe '#initialize' do

    it 'saves the passed-in message' do
      expect(subject.message).to eq message
    end

    it 'saves the passed-in error code' do
      expect(subject.error_code).to eq error_code
    end
  end
end
