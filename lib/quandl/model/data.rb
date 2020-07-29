module Quandl
  class Data < ModelBase
    include Quandl::Operations::List

    def self.create_list_from_response(_response, data)
      if !data['dataset_data']['data'].empty? &&
         data['dataset_data']['column_names'].length != data['dataset_data']['data'].first.length
        raise InvalidDataError.new('number of column names does not match number of data points in a row!',
                                   nil, nil, data)
      end
      values = data['dataset_data'].delete('data')
      metadata = data['dataset_data']
      Quandl::List.new(self, values, metadata)
    end

    def self.list_path
      'datasets/:database_code/:dataset_code/data'
    end

    def initialize(data, options = {})
      converted_column_names = options[:meta]['column_names'].map { |cn| Quandl::Util.methodize(cn) }
      @raw_data = Quandl::Util.convert_to_dates(Hash[converted_column_names.zip(data)])
      @meta = options[:meta]
    end

    def column_names
      @meta['column_names']
    end

    private

    def method_missing(method_name, *args, &block)
      return @meta[method_name.to_s] if @meta.key?(method_name.to_s)

      super
    end
  end
end
