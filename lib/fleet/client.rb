require 'fleet/connection'
require 'fleet/error'
require 'fleet/request'
require 'fleet/service_definition'
require 'fleet/client/machines'
require 'fleet/client/unit'

module Fleet
  class Client

    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options={})
      options = Fleet.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Fleet::Connection
    include Fleet::Request

    include Fleet::Client::Machines
    include Fleet::Client::Unit

    def load(name, service_def=nil)

      if service_def
        unless service_def.is_a?(ServiceDefinition)
          service_def = ServiceDefinition.new(service_def)
        end

        begin
          create_unit(name, service_def.to_unit)
        rescue Fleet::PreconditionFailed
        end
      else
        opts = { 'desiredState' => 'loaded' }
        update_unit(name, opts)
      end
    end

    def start(name)
      opts = { 'desiredState' => 'launched' }
      update_unit(name, opts)
    end

    def stop(name)
      opts = { 'desiredState' => 'loaded' }
      update_unit(name, opts)
    end

    def unload(name)
      opts = { 'desiredState' => 'inactive' }
      update_unit(name, opts)
    end

    def destroy(name)
      delete_unit(name)
    end

    def status(name)
      get_unit(name)["currentState"].to_sym
    end

    protected

    def resource_path(resource, *parts)
      parts.unshift('fleet', fleet_api_version, resource).join('/')
    end
  end
end
