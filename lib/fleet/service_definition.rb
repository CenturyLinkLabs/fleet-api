require 'digest/sha1'

module Fleet
  class ServiceDefinition

    attr_reader :name

    def initialize(name, service_def={})
      @name = name
      @service_def = service_def
    end

    def to_unit
      { 'Raw' => raw }
    end

    def to_job
      {
        'Name' => name,
        'UnitHash' => sha1_byte_array
      }
    end

    def sha1
      Digest::SHA1.hexdigest raw
    end

    private

    def raw
      raw_string = ''

      @service_def.each do |heading, section|
        raw_string += "[#{heading}]\n"

        if section.is_a?(Enumerable)
          section.each do |key, value|
            raw_string += "#{key}=#{value}\n"
          end
        end

        raw_string += "\n"
      end

      raw_string.chomp
    end

    def sha1_byte_array
      Digest::SHA1.digest(raw).unpack('C20')
    end
  end
end
