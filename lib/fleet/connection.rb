require 'excon'

module Fleet
  module Connection

    def connection
      options = {
        read_timeout: read_timeout,
        connect_timeout: open_timeout,
        headers: { 'User-Agent' => user_agent, 'Accept' => 'application/json' }
      }

      uri = URI.parse(fleet_api_url)
      if uri.scheme == 'unix'
        uri, options = 'unix:///', { socket: uri.path }.merge(options)
      else
        uri = fleet_api_url
      end

      Excon.new(uri, options)
    end

    private

    def user_agent
      ua_chunks = []
      ua_chunks << "fleet/#{Fleet::VERSION}"
      ua_chunks << "(#{RUBY_ENGINE}; #{RUBY_VERSION}p#{RUBY_PATCHLEVEL}; #{RUBY_PLATFORM})"
      ua_chunks << "excon/#{Excon::VERSION}"
      ua_chunks.join(' ')
    end
  end
end
