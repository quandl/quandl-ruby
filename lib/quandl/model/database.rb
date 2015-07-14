module Quandl
  class Database < ModelBase
    has_many :datasets, path: ->(database) { "/datasets/#{database.code}", }

    # metadata
    # def get(database_code, opts={})
    # end

    # def all(opts={})
    #   opts[:params]
    # end

    # def datasets(opts={})
    #   #Quandl::Dataset.all(database_code)
    # end

    # # all(params: { page: 1,  })
    # # return only the download url
    # def bulk_download_url(opts={})
    # end
  end
end
