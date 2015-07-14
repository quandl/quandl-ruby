module Quandl
  class List
    attr_reader :meta
    attr_reader :values

    def initialize(klass, values, meta)
      @klass = klass
      @values = values.map{ |v| klass.new(v) }
      @meta = meta
    end

    def more_results?
      @meta[:total_pages] > @meta[:current_page]
    end

    def method_missing(method_name, *args, &block)
      return @meta[method_name] if @meta.key?(method_name)
      return @values.method(method_name).call(*args, &block) if @values.respond_to?(method_name)
      super
    end
  end
end
