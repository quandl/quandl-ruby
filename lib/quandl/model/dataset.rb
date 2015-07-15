module Quandl
  class Dataset < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List

    def database
      Quandl::Database.get(database_code)
    end

    def data
      Quandl::Data.all(params: { database_code: database_code, dataset_code: dataset_code })
    end
  end
end
