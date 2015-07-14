module Quandl
  class Database < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List

    def datasets(query, options = {})
      Quandl::Dataset.all({ params: { query: query }}.deep_merge(options))
    end

    def bulk_download_url(options = {})
    end
  end
end
