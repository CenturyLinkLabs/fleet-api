require 'spec_helper'

describe Fleet::Connection do

  describe 'connection options' do

    let(:open_timeout) { 30 }
    let(:read_timeout) { 40 }

    subject do
      Fleet::Client.new(
        open_timeout: open_timeout,
        read_timeout: read_timeout).connection
    end

    describe 'open_timeout' do
      it 'matches the the specified timeout value' do
        expect(subject.data[:connect_timeout]).to eq open_timeout
      end
    end

    describe 'read_timeout' do
      it 'matches the the specified timeout value' do
        expect(subject.data[:read_timeout]).to eq read_timeout
      end
    end

    context 'when URL is HTTP' do
      let(:url) { 'http://foo.com/bar' }

      subject do
        Fleet::Client.new(fleet_api_url: url).connection
      end
      describe 'scheme' do
        it 'matches the scheme of the URL' do
          expect(subject.data[:scheme]).to eq 'http'
        end
      end

      describe 'host' do
        it 'matches the host of the URL' do
          expect(subject.data[:host]).to eq 'foo.com'
        end
      end

      describe 'port' do
        it 'matches the port of the URL' do
          expect(subject.data[:port]).to eq 80
        end
      end

      describe 'prefix' do
        it 'matches the path of the URL' do
          expect(subject.data[:path]).to eq '/bar'
        end
      end
    end

    context 'when URL is UNIX' do
      let(:url) { 'unix:///foo/bar.socket' }

      subject do
        Fleet::Client.new(fleet_api_url: url).connection
      end

      describe 'scheme' do
        it 'matches the scheme of the URL' do
          expect(subject.data[:scheme]).to eq 'unix'
        end
      end

      describe 'socket' do
        it 'matches the port of the URL' do
          expect(subject.data[:socket]).to eq '/foo/bar.socket'
        end
      end
    end

  end
end
