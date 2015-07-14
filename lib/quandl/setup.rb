Her::API.setup url: 'https://www.quandl.com/api/v3' do |c|
  c.use Quandl::Middleware::TokenAuthentication

  c.use Faraday::Request::Multipart
  c.use Faraday::Request::UrlEncoded
  c.use Her::Middleware::DefaultParseJSON
  c.use Faraday::Adapter::NetHttp
end
