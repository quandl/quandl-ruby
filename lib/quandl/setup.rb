Her::API.setup url: 'https://www.quandl.com/api/v3' do |c|
  binding.pry
  # c.use Quandl::Middleware::TokenAuthentication
  # c.use TrackRequestSource
  c.use Faraday::Request::Multipart
  c.use Faraday::Request::UrlEncoded
  # c.use Quandl::Client::Middleware::ParseJSON
  c.use Faraday::Adapter::NetHttp
end
