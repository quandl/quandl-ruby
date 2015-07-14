module Quandl
  class Database < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List

    def datasets(query = nil, options = {})
      Quandl::Dataset.all({ params: { query: query, per_page: 25, page: 1 }}.deep_merge(options))
    end

    def bulk_download_url(options = {})
    end
  end
end
