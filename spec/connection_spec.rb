require 'spec_helper'

describe 'Connection' do
  describe 'error handling' do
    let(:url) { 'databases' }
    let(:http_verb) { :get }
    context 'when limit exceeded' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QELx04'), status: 429)
      end

      it 'throws limit exceeded error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::LimitExceededError)
      end
    end

    context 'when internal server error' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QEMx01'), status: 500)
      end

      it 'throws internal server error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::InternalServerError)
      end
    end

    context 'when invalid api key format' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QEAx01'), status: 400)
      end

      it 'throws authentication error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::AuthenticationError)
      end
    end

    context 'when not authorized' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QEPx02'), status: 403)
      end

      it 'throws forbidden error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::ForbiddenError)
      end
    end

    context 'when incorrect request params' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QESx03'), status: 422)
      end

      it 'throws invalid request error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::InvalidRequestError)
      end
    end

    context 'when not found' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QECx05'), status: 404)
      end

      it 'throws not found error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::NotFoundError)
      end
    end

    context 'when maintenance mode' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QEXx01'), status: 503)
      end

      it 'throws service unavailable error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::ServiceUnavailableError)
      end
    end

    context 'all other api response errors' do
      before do
        stub_request(:any, 'https://www.quandl.com/api/v3/databases')
          .to_return(body: build_quandl_error('QEZx02'), status: 400)
      end

      it 'throws generic quandl error' do
        expect { Quandl::Connection.request(http_verb, url) }.to raise_error(Quandl::QuandlError)
      end
    end
  end

  describe 'building request options' do
    let(:url) { 'databases' }
    let(:http_verb) { :get }
    let(:headers) { { request_source: 'public_api' } }
    let(:params) { { 'per_page' => '10', 'page' => '2' } }
    let(:expected_headers) do
      {
        request_source: 'public_api',
        accept: 'application/json, application/vnd.quandl+json;version=2015-04-09',
        x_api_token: 'api_token'
      }
    end
    before do
      stub_request(:any, 'https://www.quandl.com/api/v3/databases')
      Quandl::Config.api_key = 'api_token'
      Quandl::Config.api_version = '2015-04-09'
    end

    it 'builds the request' do
      expect(Quandl::Connection).to receive(:execute_request)
        .with(url: 'https://www.quandl.com/api/v3/databases?page=2&per_page=10',
              headers: expected_headers, method: :get).and_return('{}')
      Quandl::Connection.request(http_verb, url, params: params, headers: headers)
    end
  end
end

def build_quandl_error(quandl_error, message = nil)
  quandl_error = {
    quandl_error: {
      code: quandl_error,
      message: message
    }
  }
  quandl_error.to_json
end
