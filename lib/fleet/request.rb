require 'fleet/version'

module Fleet
  module Request

    private

    [:get, :head, :put, :post, :delete].each do |method|
      define_method(method) do |path, options={}, headers={}|
        request(connection, method, path, options, headers)
      end
    end

    def request(connection, method, path, options, headers)
      options ||= {}

      response = connection.send(method) do |request|
        request.options[:open_timeout] = open_timeout
        request.options[:timeout] = read_timeout
        request.headers = {
          user_agent: user_agent,
          accept: 'application/json'
        }.merge(headers)

        request.path = URI.escape(path).gsub(/@/, '%40')

        case method
        when :delete, :get, :head
          request.params = options unless options.empty?
        when :post, :put
          if options.key?(:querystring)
            request.params = options[:querystring]
            request.body = options[:body]
          else
            request.body = options unless options.empty?
          end
        end
      end

      response.body
    rescue Faraday::Error::ConnectionFailed => ex
      raise Fleet::ConnectionError, ex.message
    end

    private

    def user_agent
      ua_chunks = []
      ua_chunks << "fleet/#{Fleet::VERSION}"
      ua_chunks << "(#{RUBY_ENGINE}; #{RUBY_VERSION}p#{RUBY_PATCHLEVEL}; #{RUBY_PLATFORM})"
      ua_chunks << "faraday/#{Faraday::VERSION}"
      ua_chunks << "(#{adapter})"
      ua_chunks.join(' ')
    end
  end
end
