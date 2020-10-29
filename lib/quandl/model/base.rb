module Quandl
  class ModelBase
    def initialize(data, _options = {})
      @raw_data = ActiveSupport::HashWithIndifferentAccess.new(data.transform_keys { |k| Quandl::Util.methodize(k) })
    end

    def data_fields
      @raw_data.keys.map(&:to_s)
    end

    def column_names
      @raw_data.keys.map(&:to_s).map(&:titleize)
    end

    def to_a
      @raw_data.values
    end

    def inspect
      @raw_data.to_s
    end

    private

    def method_missing(method_name, *args, &block)
      return @raw_data[method_name.to_s] if @raw_data.key?(method_name.to_s)
      return @raw_data.method(method_name.to_s).call(*args, &block) if @raw_data.respond_to?(method_name.to_s)

      super
    end
  end
end
