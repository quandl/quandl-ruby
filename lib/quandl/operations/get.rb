module Quandl
  module Operations
    module Get
      extend ActiveSupport::Concern
      include Quandl::Operations::Base

      class_methods do
        def get(id, options = {})
          _response, response_data = Quandl::Connection.request(:get, Quandl::Util.constructed_path(get_path, { id: id }.merge(options[:params] || {})), options)
          new(response_data[lookup_key.singularize])
        end

        # rubocop:disable Naming/AccessorMethodName
        def get_path
          default_path
        end
        # rubocop:enable Naming/AccessorMethodName
      end
    end
  end
end
