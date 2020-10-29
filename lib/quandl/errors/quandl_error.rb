# based off of stripe gem: https://github.com/stripe/stripe-ruby
module Quandl
  class QuandlError < StandardError
    attr_reader :quandl_message, :http_status, :http_body, :http_headers, :request_id, :json_body, :quandl_error_code

    # rubocop:disable Metrics/ParameterLists
    def initialize(quandl_message = nil, http_status = nil, http_body = nil, json_body = nil,
                   http_headers = nil, quandl_error_code = nil)
      @quandl_message = quandl_message
      @http_status = http_status
      @http_body = http_body
      @http_headers = http_headers || {}
      @json_body = json_body
      @quandl_error_code = quandl_error_code
      @message = build_message
    end
    # rubocop:enable Metrics/ParameterLists

    def build_message
      status_string = @http_status.nil? ? '' : "(Status #{@http_status}) "
      quandl_error_string = @quandl_error_code.nil? ? '' : "(Quandl Error #{@quandl_error_code}) "
      "#{status_string}#{quandl_error_string}#{@quandl_message}"
    end

    def to_s
      build_message
    end
  end

  class AuthenticationError < QuandlError
  end

  class InvalidRequestError < QuandlError
  end

  class LimitExceededError < QuandlError
  end

  class NotFoundError < QuandlError
  end

  class ServiceUnavailableError < QuandlError
  end

  class InternalServerError < QuandlError
  end

  class ForbiddenError < QuandlError
  end

  class InvalidDataError < QuandlError
  end
end
