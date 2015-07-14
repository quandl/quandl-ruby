module Quandl
  class Dataset < ModelBase
    belongs_to :database, foreign_key: 'database_code'

    # metadata
    # def get(database_code, dataset_code, opts={})
    # end

    # def all(opts={})
    # end

    # # actual data
    # def data(opts={})
    # end
  end
end
