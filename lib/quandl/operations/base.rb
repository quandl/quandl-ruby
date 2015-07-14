module Quandl
  module Operations
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def constructed_path(path, params = {})
          sub_params = Hash[params.map {|k, v| [":#{k}", v] }]
          sub_params = { id: nil }.merge(sub_params)
          params.delete_if {|key, value| path =~ /:#{key}/ }

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
