module Quandl
  class ApiConfig
    @@api_key = nil
    @@api_base = 'https://www.quandl.com/api/v3'
    @@api_version = nil

    class << self
      def api_key=(api_key)
        @@api_key = api_key
      end

      def api_key
        @@api_key
      end

      def api_base=(api_base)
        @@api_base = api_base
      end

      def api_base
        @@api_base
      end

      def api_version=(api_version)
        @@api_version = api_version
      end

      def api_version
        @@api_version
      end
    end
  end
end
