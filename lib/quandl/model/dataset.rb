module Quandl
  class Dataset < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List

    # belongs_to :database
    # has_many :datas

    def self.get(database_code, dataset_code, options = {})
      super(dataset_code, { params: { database_code: database_code } }.deep_merge(options))
    end

    private

    def self.get_path
      "#{self.name.demodulize.pluralize.underscore}/:database_code/:id"
    end

    # # actual data
    # def data(opts={})
    # end
  end
end
