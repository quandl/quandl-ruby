module Quandl
  module Operations
    module Base
      extend ActiveSupport::Concern

      class_methods do
        def constructed_path(path, options = {})
          new_path = path.gsub(/:id/, options.delete(:id).to_s)
          options.each do |key, value|
            new_path.gsub!(/:#{key}/, value)
          end
          new_path
        end

        def default_path
          "#{self.name.demodulize.pluralize.underscore}/:id"
        end
      end
    end
  end
end
