module Quandl
  module Middleware
    class TokenAuthentication < Faraday::Middleware
      def call(env)
        env[:request_headers]['X-API-Token'] = Quandl::ModelBase.token if Quandl::ModelBase.token.present?
        @app.call(env)
      end
    end
  end
end
