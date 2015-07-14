module Quandl
  class ModelBase
    def initialize(data)
      @raw_data = data
    end

    def method_missing(method_name, *args, &block)
      return @raw_data[method_name.to_s] if @raw_data.key?(method_name.to_s)
      super
    end
  end
end
