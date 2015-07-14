module Quandl
  class Connection
    class << self
      attr_accessor :api_key, :api_base
    end

    @api_base = 'https://www.quandl.com/api/v3'

    def self.request(http_verb, url, options = {})
      params = options.delete(:params) || {}
      headers = options.delete(:headers) || {}
      headers = { accept: 'application/json' }.merge(headers)

      request_url = api_base + '/' + url

      request_opts = { url: request_url, headers: headers, method: http_verb }

      response = execute_request(request_opts)

      # TODO: handle exceptions

      response_data = JSON.parse response

      return response, response_data
    end

    def self.execute_request(opts)
      RestClient::Request.execute(opts)
  end
  end
end
