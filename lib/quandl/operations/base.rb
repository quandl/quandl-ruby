module Quandl
  module Operations
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def constructed_path(path, params = {})
          params ||= {}
          sub_params = Hash[{ id: nil }.merge(params).map { |k, v| [':' + k.to_s, v] }]
          params.delete_if { |key, _value| path =~ /:#{key}/ }

          path = path.dup
          path.gsub!(Regexp.union(sub_params.keys), sub_params)
          path
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
