module Quandl
  class Database < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List
    # has_many :datasets, path: ->(database) { "/datasets/#{database.code}" }

    def get(_database_code, _daquery = nil)
      Dataset.where(database_code: database_code, z: query)
    end

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
