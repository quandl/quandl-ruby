module Quandl
  module Operations
    module List
      extend ActiveSupport::Concern
      include Quandl::Operations::Base

      class_methods do
        def all(options = {})
          self.new(Quandl::Connection.request(:get, constructed_path(list_path, options[:params]), options))
        end

        def list_path
          default_path
        end
      end
    end
  end
end
