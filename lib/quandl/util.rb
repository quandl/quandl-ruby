module Quandl
  class Util
    def self.methodize(string)
      string.gsub(/\./, '').parameterize.gsub(/\-/, '_')
    end

    def self.convert_to_dates(hash)
      return hash unless hash.is_a?(Hash)
      hash.update(hash) do |_k, v|
        if v.is_a?(String) && v =~ /^\d{4}-\d{2}-\d{2}$/ # Date
          Date.parse(v)
        elsif v.is_a?(String) && v =~ /^\d{4}-\d{2}-\d{2}T[\d:\.]+Z/ # DateTime
          Time.parse(v)
        elsif v.is_a?(Array)
          v.map { |ao| convert_to_dates(ao) }
        elsif v.is_a?(Hash)
          convert_to_dates(v)
        else
          v
        end
      end
      hash
    end
  end
end
