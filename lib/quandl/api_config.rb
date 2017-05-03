# frozen_string_literal: true

module Quandl
  class ApiConfig
    API_KEY_THREAD_KEY = 'quandl_api_key'.freeze
    API_BASE_THREAD_KEY = 'quandl_api_base'.freeze
    API_VERSION_THREAD_KEY = 'quandl_api_version_key'.freeze

    @api_key = nil
    @api_base = nil
    @api_version = nil

    class << self
      def api_key=(api_key)
        @api_key = api_key if @api_key.nil?
        Thread.current[API_KEY_THREAD_KEY] = api_key
      end

      def api_key
        Thread.current[API_KEY_THREAD_KEY] || @api_key
      end

      def api_base=(api_base)
        @api_base = api_base if @api_base.nil?
        Thread.current[API_BASE_THREAD_KEY] = api_base
      end

      def api_base
        Thread.current[API_BASE_THREAD_KEY] || @api_base || 'https://www.quandl.com/api/v3'
      end

      def api_version=(api_version)
        @api_version = api_base if @api_version.nil?
        Thread.current[API_VERSION_THREAD_KEY] = api_version
      end

      def api_version
        Thread.current[API_VERSION_THREAD_KEY] || @api_version
      end

      def reset
        @api_key = nil
        @api_base = nil
        @api_version = nil
      end
    end
  end
end
