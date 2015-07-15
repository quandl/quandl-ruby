module Quandl
  class List
    attr_reader :meta
    attr_reader :values

    def initialize(klass, values, meta)
      @klass = klass
      @values = values.map { |v| klass.new(v, meta: meta) }
      @meta = meta
    end

    def more_results?
      @meta['total_pages'] > @meta['current_page']
    end

    def to_a
      @values.map(&:to_a)
    end

    def to_csv
      fail(StandardError, 'No values to export') if @values.empty?

      CSV.generate do |csv|
        csv << @values.first.column_names
        @values.each do |row|
          csv << row.to_a
        end
      end
    end

    def inspect
      @meta.to_s
    end

    private

    def method_missing(method_name, *args, &block)
      return @meta[method_name.to_s] if @meta.key?(method_name.to_s)
      return @values.method(method_name).call(*args, &block) if @values.respond_to?(method_name)
      super
    end
  end
end
