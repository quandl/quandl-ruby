module Quandl
  module Operations
    module List
      extend ActiveSupport::Concern
      include Quandl::Operations::Base

      class_methods do
        def all(options = {})
          response, response_data = Quandl::Connection.request(:get, constructed_path(list_path, options[:params]), options)
          Quandl::List.new(self, response_data[lookup_key], response_data['meta'])
        end

        def list_path
          default_path
        end
      end
    end
  end
end
