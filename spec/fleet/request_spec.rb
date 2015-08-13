require 'spec_helper'

describe Fleet::Request do

  subject { Fleet::Client.new }

  let(:path) { '/foo bar@' }

  let(:response) do
    double(:response, body: '{"name":"foo"}', status: 200)
  end

  let(:connection) { double(:connection) }

  before do
    allow(connection).to receive(:send).and_return(response)
    allow(subject).to receive(:connection).and_return(connection)
  end

  describe '#get' do

    let(:options) do
      { foo: 'bar' }
    end

    it 'invokes #get on the connection with the correct params' do
      opts = { path: '/foo%20bar%40', query: options }
      expect(connection).to receive(:send).with(:get, opts)

      subject.send(:get, path, options)
    end

    it 'returns the parsed response body' do
      expect(subject.send(:get, path, options)).to eq('name' => 'foo')
    end

    context 'when there is pagination' do
      let(:first_response) do
        double(:first_response, body: '{"things":[{"name":"foo"}], "nextPageToken":"123"}', status: 200)
      end
      let(:second_response) do
        double(:second_response, body: '{"things":[{"name":"bah"}], "nextPageToken":"456"}', status: 200)
      end
      let(:third_response) do
        double(:second_response, body: '{"things":[{"name":"tah"}]}', status: 200)
      end

      it 'merges the responses' do
        expect(connection).to receive(:send).with(:get, anything).and_return(first_response)
        expect(connection).to receive(:send).with(:get, hash_including(query: { 'nextPageToken' => '123' })).and_return(second_response)
        expect(connection).to receive(:send).with(:get, hash_including(query: {'nextPageToken' => '456'})).and_return(third_response)

        expect(subject.send(:get, path)).to eql(
          'things' => [{ 'name' => 'foo' }, { 'name' => 'bah' }, { 'name' => 'tah' }]
        )
      end
    end

    context 'when there is a SocketError' do
      before do
        allow(connection).to receive(:send)
          .and_raise(Excon::Errors::SocketError, Excon::Errors::Error.new('oops'))
      end

      it 'raises a Fleet::ConnectionError' do
        expect { subject.send(:get, path, options) }.to raise_error(Fleet::ConnectionError)
      end
    end

    context 'when a non-200 status code is returned' do
      let(:response) do
        double(:response, body: '{"error": {"message": "oops", "code": "400"}}', status: 400)
      end

      it 'raises a Fleet::ConnectionError' do
        expect { subject.send(:get, path, options) }.to raise_error(Fleet::BadRequest, 'oops')
      end
    end
  end

  describe '#put' do

    let(:options) do
      { foo: 'bar' }
    end

    it 'invokes #put on the connection with the correct params' do
      opts = {
        path: '/foo%20bar%40',
        headers: { 'Content-Type' => 'application/json' },
        body: JSON.dump(options)
      }
      expect(connection).to receive(:send).with(:put, opts)

      subject.send(:put, path, options)
    end

    it 'returns true' do
      expect(subject.send(:put, path, options)).to eq(true)
    end
  end

  describe '#delete' do

    it 'invokes #get on the connection with the correct params' do
      opts = { path: '/foo%20bar%40' }
      expect(connection).to receive(:send).with(:delete, opts)

      subject.send(:delete, path, nil)
    end

    it 'returns true' do
      expect(subject.send(:delete, path, nil)).to eq(true)
    end
  end

end
