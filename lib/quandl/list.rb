module Quandl
  class List
    attr_reader :meta
    attr_reader :values

    def initialize(klass, values, meta)
      @klass = klass
      @values = values
      @meta = meta
    end

    delegate :each, :values

    def more_results?
      @meta[:total_pages] > @meta[:current_page]
    end

    def method_missing(method_name, *args, &block)
      return @meta[method_name] if @meta.key?(method_name)
      super
    end
  end
end
