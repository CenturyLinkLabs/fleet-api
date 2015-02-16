require 'logger'

module Fleet
  module Configuration

    VALID_OPTIONS_KEYS = [
      :fleet_api_url,
      :fleet_api_version,
      :open_timeout,
      :read_timeout,
      :logger
    ]

    DEFAULT_FLEET_API_URL = ENV['FLEETCTL_ENDPOINT'] || 'unix:///var/run/fleet.sock'
    DEFAULT_FLEET_API_VERSION = 'v1'
    DEFAULT_OPEN_TIMEOUT = 2
    DEFAULT_READ_TIMEOUT = 5
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
      self.fleet_api_url = DEFAULT_FLEET_API_URL
      self.fleet_api_version = DEFAULT_FLEET_API_VERSION
      self.open_timeout = DEFAULT_OPEN_TIMEOUT
      self.read_timeout = DEFAULT_READ_TIMEOUT
      self.logger = DEFAULT_LOGGER
    end
  end
end
