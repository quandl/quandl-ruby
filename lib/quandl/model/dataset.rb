module Quandl
  class Dataset < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List

    # rubocop:disable Naming/AccessorMethodName
    def self.get_path
      "#{default_path}/metadata"
    end
    # rubocop:enable Naming/AccessorMethodName

    def database
      Quandl::Database.get(database_code)
    end

    def data(options = {})
      Quandl::Data.all({ params: { database_code: database_code, dataset_code: dataset_code } }.deep_merge(options))
    end

    def column_names
      @raw_data['column_names']
    end
  end
end
