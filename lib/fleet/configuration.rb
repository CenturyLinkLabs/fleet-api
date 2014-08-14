require 'faraday'
require 'logger'

module Fleet
  module Configuration

    VALID_OPTIONS_KEYS = [
      :adapter,
      :fleet_api_url,
      :open_timeout,
      :read_timeout,
      :ssl_options,
      :proxy,
      :logger
    ]

    DEFAULT_ADAPTER = Faraday.default_adapter
    DEFAULT_ETCD_API_URL = ENV['FLEETCTL_ENDPOINT']
    DEFAULT_OPEN_TIMEOUT = 2
    DEFAULT_READ_TIMEOUT = 5
    DEFAULT_SSL_OPTIONS = { verify: false }
    DEFAULT_LOGGER = ::Logger.new(STDOUT)

    attr_accessor(*VALID_OPTIONS_KEYS)

    def self.extended(base)
      base.reset
    end

    # Return a has of all the current config options
    def options
      VALID_OPTIONS_KEYS.each_with_object({}) { |k, o| o[k] = send(k) }
    end

    def reset
      self.adapter = DEFAULT_ADAPTER
      self.fleet_api_url = DEFAULT_ETCD_API_URL
      self.open_timeout = DEFAULT_OPEN_TIMEOUT
      self.read_timeout = DEFAULT_READ_TIMEOUT
      self.ssl_options = DEFAULT_SSL_OPTIONS
      self.logger = DEFAULT_LOGGER
    end
  end
end
