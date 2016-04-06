module Fleet
  class Client
    module Machines

      MACHINES_RESOURCE = 'machines'

      def list_machines
        get(machines_path)
      end

      private

      def machines_path(*parts)
        resource_path(MACHINES_RESOURCE, *parts)
      end

    end
  end
end
