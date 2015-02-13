module Fleet
  class ServiceDefinition

    def initialize(service_def={})
      @service_def = service_def
    end

    def to_unit
      {
        'desiredState' => 'loaded',
        'options' => options
      }
    end

    private

    def options
      @service_def.each_with_object([]) do |(section, options), h|
        options.each do |name, value|
          if value.is_a?(Enumerable)
            value.each do |v|
              h << {
              'section' => section,
              'name' => name,
              'value' => v
              }
            end
          else
            h << {
              'section' => section,
              'name' => name,
              'value' => value
            }
          end
        end
      end
    end
  end
end
