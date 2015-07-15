# based off of stripe gem: https://github.com/stripe/stripe-ruby
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

      binding.pry

      case http_verb
      when :get, :head, :delete
        request_url = request_url + '?' + params.to_query
      else
        put 'TODO: implement PUT/POST'
      end

      request_opts = { url: request_url, headers: headers, method: http_verb }

      begin
        response = execute_request(request_opts)
      rescue RestClient::ExceptionWithResponse => e
        if e.response
          handle_api_error(e.response)
        else
          raise
        end
      end

      response_data = parse(response)

      [response, response_data]
    end

    def self.execute_request(opts)
      RestClient::Request.execute(opts)
    end

    def self.parse(response)
      JSON.parse(response)
      rescue JSON::ParserError
        raise general_error(response.code, response.body)
    end

    def self.general_error(rcode, rbody)
      QuandlError.new("Invalid response object from API: #{rbody.inspect} " \
                   "(HTTP response code was #{rcode})", rcode, rbody)
    end

    def self.handle_api_error(resp)
      error_body = parse(resp.body)
      code = error_body['quandl_error']['code']
      message = error_body['quandl_error']['message']
      code_letter = code.match(/QE([a-zA-Z])x/).captures.first

      case code_letter
      when 'L'
        raise LimitExceededError.new(message, resp.code, resp.body, error_body,
                                     resp.headers, code)
      when 'M'
        raise InternalServerError.new(message, resp.code, resp.body, error_body,
                                      resp.headers, code)
      when 'A'
        raise AuthenticationError.new(message, resp.code, resp.body, error_body,
                                      resp.headers, code)
      when 'P'
        raise ForbiddenError.new(message, resp.code, resp.body, error_body,
                                 resp.headers, code)
      when 'S'
        raise InvalidRequestError.new(message, resp.code, resp.body, error_body,
                                      resp.headers, code)
      when 'C'
        raise NotFoundError.new(message, resp.code, resp.body, error_body,
                                resp.headers, code)
      when 'X'
        raise ServiceUnavailableError.new(message, resp.code, resp.body,
                                          error_body, resp.headers, code)
      else
        raise QuandlError.new(message, resp.code, resp.body, error_body,
                              resp.headers, code)
      end
    end
  end
end
