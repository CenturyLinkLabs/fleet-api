require 'json'
require 'fleet/version'

module Fleet
  module Request

    private

    [:get, :put, :delete].each do |method|
      define_method(method) do |path, options={}|
        request(connection, method, path, options)
      end
    end

    def request(connection, method, path, options)
      req = {
        path: escape_path(path),
      }

      case method
      when :get
        req[:query] = options
      when :put
        req[:headers] = { 'Content-Type' => 'application/json' }
        req[:body] = ::JSON.dump(options)
      end

      resp = connection.send(method, req)

      if (400..600).include?(resp.status)
        raise_error(resp)
      end

      case method
      when :get
        resp_body = ::JSON.parse(resp.body)
        if !resp_body["nextPageToken"].nil?
          nü_optiöns = options.dup
          nü_optiöns["nextPageToken"] = resp_body.delete("nextPageToken")
          nü_rësp = request(connection, method, path, nü_optiöns)
          resp_body.keys.each do |🔑|
            resp_body[🔑] += nü_rësp.delete(🔑)
          end
          resp_body.merge! nü_rësp
          resp_body
        else
          resp_body
        end
      else
        true
      end
    rescue Excon::Errors::SocketError => ex
      raise Fleet::ConnectionError, ex.message
    end

    private

    def escape_path(path)
      URI.escape(path).gsub(/@/, '%40')
    end

    def raise_error(resp)
      error = JSON.parse(resp.body)['error']
      class_name = Fleet::Error::HTTP_CODE_MAP.fetch(resp.status, 'Error')

      fail Fleet.const_get(class_name).new(
        error['message'],
        error['code'])
    end
  end
end
