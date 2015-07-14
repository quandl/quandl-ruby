module Quandl
  class ModelBase
    include Her::Model
    parse_root_in_json true, format: :active_model_serializers

    class << self
      attr_accessor :token
    end
  end
end
