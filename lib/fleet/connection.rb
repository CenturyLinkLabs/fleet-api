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
        faraday.request :json
        faraday.response :json
        faraday.response :raise_fleet_error
        faraday.response :follow_redirects
        faraday.adapter adapter
      end
    end
  end
end
