module Quandl
  module Operations
    module List
      extend ActiveSupport::Concern
      include Quandl::Operations::Base

      class_methods do
        def all(options = {})
          response, response_data = Quandl::Connection.request(:get, Quandl::Util.constructed_path(list_path, options[:params]), options)
          create_list_from_response(response, response_data)
        end

        def create_list_from_response(_response, data)
          Quandl::List.new(self, data[lookup_key], data['meta'])
        end

        def list_path
          default_path
        end
      end
    end
  end
end
