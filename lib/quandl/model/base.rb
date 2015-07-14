module Quandl
  class ModelBase
    class << self
      attr_accessor :token
    end

    def initialize(id, options = {})

    end

    def method_missing(method_name, value)
      @raw_data[method_name] if @raw_data.key?(method_name)
    end
  end
end
