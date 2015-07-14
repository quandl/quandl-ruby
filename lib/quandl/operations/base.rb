module Quandl
  module Operations
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def constructed_path(path, params = {})
          new_path = path.gsub(/:id/, params.delete(:id).to_s)
          params.each do |key, value|
            return unless new_path =~ /:#{key}/

            new_path.gsub!(/:#{key}/, value)
            params.delete(key)
          end
          new_path
        end

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
