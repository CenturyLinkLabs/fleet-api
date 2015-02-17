module Fleet
  class Client
    module State

      STATE_RESOURCE = 'state'

      def list_states(options={})
        get(state_path, options)
      end

      private

      def state_path(*parts)
        resource_path(STATE_RESOURCE, *parts)
      end

    end
  end
end

