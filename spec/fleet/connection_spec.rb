require 'spec_helper'

describe Fleet::Connection do

  describe 'registered middleware' do

    subject { Fleet::Client.new.connection }

    handlers = [
      Faraday::Request::UrlEncoded,
      FaradayMiddleware::ParseJson,
      Fleet::Middleware::Response::RaiseError,
      FaradayMiddleware::FollowRedirects,
      Faraday::Adapter::NetHttp
    ]

    handlers.each do |handler|
      it { expect(subject.builder.handlers).to include handler }
    end

    it "includes exactly #{handlers.count} handlers" do
      expect(subject.builder.handlers.count).to eql handlers.count
    end
  end

  describe 'connection options' do

    let(:url) { 'http://foo.com/bar' }
    let(:ssl_options) { { verify: true } }
    let(:proxy) { 'http://proxy.com' }

    subject do
      Fleet::Client.new(
        fleet_api_url: url,
        ssl_options: ssl_options,
        proxy: proxy).connection
    end

    describe 'scheme' do
      it 'matches the scheme of the URL' do
        expect(subject.scheme).to eq 'http'
      end
    end

    describe 'host' do
      it 'matches the host of the URL' do
        expect(subject.host).to eq 'foo.com'
      end
    end

    describe 'port' do
      it 'matches the port of the URL' do
        expect(subject.port).to eq 80
      end
    end

    describe 'path_prefix' do
      it 'matches the path of the URL' do
        expect(subject.path_prefix).to eq '/bar'
      end
    end

    describe 'ssl' do
      it 'matches the specified SSL options' do
        expect(subject.ssl.to_h).to include(ssl_options)
      end
    end

    describe 'proxy' do
      it 'matches the specified SSL options' do
        expect(subject.proxy[:uri].to_s).to eq proxy
      end
    end

  end
end
