require 'faraday'
require 'faraday_middleware'
require 'middleware/response/raise_error'

module Fleet
  module Connection

    def connection
      options = {
        url: fleet_api_url,
        ssl: ssl_options,
        proxy: proxy
      }

      Faraday.new(options) do |faraday|
        faraday.request :url_encoded
        faraday.response :json
        faraday.response :raise_error
        faraday.adapter adapter
      end
    end
  end
end
