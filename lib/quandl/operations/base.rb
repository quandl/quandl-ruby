module Quandl
  module Operations
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def default_path
          "#{lookup_key}/:id"
        end

        def lookup_key
          name.demodulize.pluralize.underscore
        end
      end
    end
  end
end
