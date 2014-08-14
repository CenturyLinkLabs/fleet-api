require 'fleet/configuration'
require 'fleet/client'

module Fleet
  extend Configuration

  def self.new(options={})
    Fleet::Client.new(options)
  end

  def self.configure
    yield self
    true
  end
end
