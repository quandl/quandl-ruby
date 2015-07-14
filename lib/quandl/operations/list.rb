module Quandl
  module Operations
    module List
      extend ActiveSupport::Concern
      include Quandl::Operations::Base

      class_methods do
        def all(options = {})
          meta, response_body = Quandl::Connection.request(:get, constructed_path(list_path, options[:params]), options)
          Quandl::List.new(self, response_body[lookup_key], meta)
        end

        def list_path
          default_path
        end
      end
    end
  end
end
