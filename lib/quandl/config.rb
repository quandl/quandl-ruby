module Quandl
  class Config
    @api_base = 'https://www.quandl.com/api/v3'
    class << self
      attr_accessor :api_key, :api_base, :api_version
    end
  end
end
