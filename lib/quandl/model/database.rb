module Quandl
  class Database < ModelBase
    include Quandl::Operations::Get
    include Quandl::Operations::List

    def datasets(options = {})
      Quandl::Dataset.all({ params: { database_code: database_code, query: nil, page: 1 } }.deep_merge(options))
    end

    def bulk_download_url(options = {})
      options.assert_valid_keys(:params)

      url = bulk_download_path
      url = "#{Quandl::ApiConfig.api_base}/#{url}"
      url = Quandl::Util.constructed_path(url, id: database_code)

      params = options[:params] || {}
      params['api_key'] = Quandl::ApiConfig.api_key if Quandl::ApiConfig.api_key
      params['api_version'] = Quandl::ApiConfig.api_version if Quandl::ApiConfig.api_version

      url += "?#{params.to_query}" if params.any?
      url
    end

    def bulk_download_path
      path = "#{self.class.default_path}/data"
      Quandl::Util.constructed_path(path, id: database_code)
    end

    def bulk_download_to_file(file_or_folder_path, options = {})
      raise(QuandlError, 'You must specific a file handle or folder to write to.') if file_or_folder_path.blank?

      # Retrieve the location of the bulk download url
      path = bulk_download_path
      download_url = Quandl::Connection.request(:get, path, options) do |response, _request, _result, &_block|
        if response.code == 302
          response.headers[:location]
        else
          Quandl::Connection.handle_api_error(response) if response&.body
          raise(QuandlError, 'Unexpected result when fetching bulk download URI.')
        end
      end
      uri = URI.parse(download_url)

      # Check that we can write to the directory
      file = file_or_folder_path
      unless file_or_folder_path.is_a?(File)
        file_or_folder_path = Pathname.new(file_or_folder_path.to_s).join(File.basename(uri.path)) if File.directory?(file_or_folder_path)
        file = File.open(file_or_folder_path, 'wb')
      end

      # Download the file
      begin
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        http.request_get(uri.request_uri) do |resp|
          resp.read_body do |segment|
            file.write(segment)
          end
        end
      ensure
        file.close
      end
      file.path
    end
  end
end
