module Quandl
  class Connection
    class << self
      attr_accessor :api_key, :api_base, :api_version
    end

    @api_base = 'https://www.quandl.com/api/v3'

    def self.request(http_verb, url, options = {})
      params = options.delete(:params) || {}
      headers = options.delete(:headers) || {}
      accept_value = 'application/json'
      accept_value += ", application/vnd.quandl+json;version=#{api_version}" if api_version
      headers = { accept: accept_value }.merge(headers)
      headers = { x_api_token: api_key }.merge(headers) if api_key

      request_url = api_base + '/' + url

      case http_verb
      when :get, :head, :delete
        request_url = request_url + '?' + params.to_query
      else
        put "TODO: implement"
      end

      request_opts = { url: request_url, headers: headers, method: http_verb }

      begin
        response = execute_request(request_opts)
      rescue RestClient::ExceptionWithResponse => e
        binding.pry
        if e.response
          #handle_api_error(e.response)
        else
          #handle_restclient_error(e, api_base_url)
        end
      end

      binding.pry

      response_data = parse(response)

      return response, response_data
    end

    def self.execute_request(opts)
      RestClient::Request.execute(opts)
    end

    def self.parse(response)
      response_data = JSON.parse(response)
      rescue JSON::ParserError
        raise general_api_error(response.code, response.body)
    end

    def self.general_api_error(rcode, rbody)
      APIError.new("Invalid response object from API: #{rbody.inspect} " +
                   "(HTTP response code was #{rcode})", rcode, rbody)
    end
  end
end
