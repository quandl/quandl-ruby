module Quandl
  class ApiConfig
    API_KEY_THREAD_KEY = 'quandl_api_key'
    API_BASE_THREAD_KEY = 'quandl_api_base'
    API_VERSION_THREAD_KEY = 'quandl_api_version_key'

    class << self
      def api_key=(api_key)
        Thread.current[API_KEY_THREAD_KEY] = api_key
      end

      def api_key
        Thread.current[API_KEY_THREAD_KEY]
      end

      def api_base=(api_base)
        Thread.current[API_BASE_THREAD_KEY] = api_base
      end

      def api_base
        Thread.current[API_BASE_THREAD_KEY] || 'https://www.quandl.com/api/v3'
      end

      def api_version=(api_version)
        Thread.current[API_VERSION_THREAD_KEY] = api_version
      end

      def api_version
        Thread.current[API_VERSION_THREAD_KEY]
      end
    end
  end
end
