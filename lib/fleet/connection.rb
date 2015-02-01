require 'faraday'
require 'faraday_middleware'
require 'fleet/middleware/response/raise_error'

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
        # faraday.response :raise_fleet_error
        faraday.use Fleet::Middleware::Response::RaiseError
        faraday.response :follow_redirects
        faraday.adapter adapter
      end
    end
  end
end
