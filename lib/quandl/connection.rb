module Quandl
  class Connection
    def self.request(http_verb, url, options = {}, &block)
      params = options.delete(:params) || {}
      headers = options.delete(:headers) || {}
      accept_value = 'application/json'
      accept_value += ", application/vnd.quandl+json;version=#{ApiConfig.api_version}" if ApiConfig.api_version
      headers = { accept: accept_value, request_source: 'ruby', request_source_version: Quandl::VERSION }.merge(headers)
      headers = { x_api_token: ApiConfig.api_key }.merge(headers) if ApiConfig.api_key

      request_url = ApiConfig.api_base + '/' + url
      request_url = request_url + '?' + params.to_query if params.present?

      request_opts = { url: request_url, headers: headers, method: http_verb }
      response = execute_request(request_opts, &block)

      return response if block_given?

      response_data = Quandl::Util.convert_to_dates(parse(response))
      [response, response_data]
    end

    def self.execute_request(opts, &block)
      RestClient::Request.execute(opts, &block)
    rescue RestClient::ExceptionWithResponse => e
      handle_api_error(e.response) if e.response
      raise e
    end

    def self.parse(response)
      ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(response))
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
        fail LimitExceededError.new(message, resp.code, resp.body, error_body,
                                    resp.headers, code)
      when 'M'
        fail InternalServerError.new(message, resp.code, resp.body, error_body,
                                     resp.headers, code)
      when 'A'
        fail AuthenticationError.new(message, resp.code, resp.body, error_body,
                                     resp.headers, code)
      when 'P'
        fail ForbiddenError.new(message, resp.code, resp.body, error_body,
                                resp.headers, code)
      when 'S'
        fail InvalidRequestError.new(message, resp.code, resp.body, error_body,
                                     resp.headers, code)
      when 'C'
        fail NotFoundError.new(message, resp.code, resp.body, error_body,
                               resp.headers, code)
      when 'X'
        fail ServiceUnavailableError.new(message, resp.code, resp.body,
                                         error_body, resp.headers, code)
      else
        fail QuandlError.new(message, resp.code, resp.body, error_body,
                             resp.headers, code)
      end
    end
  end
end
