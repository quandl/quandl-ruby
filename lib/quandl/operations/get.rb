module Quandl
  module Operations
    module Get
      extend ActiveSupport::Concern
      include Quandl::Operations::Base

      class_methods do
        def get(id, options = {})
          response = Quandl::Connection.request(:get, constructed_path(get_path, { id: id }.merge(options[:params])), options)
          new(response.body)
        end

        # rubocop:disable Style/AccessorMethodName
        def get_path
          default_path
        end
        # rubocop:enable Style/AccessorMethodName
      end
    end
  end
end
