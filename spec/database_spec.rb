require 'spec_helper'

describe 'Database' do
  let(:database) { { database: build(:database, database_code: 'NSE') }.with_indifferent_access }
  let(:databases) { { databases: build_list(:database, 10) } }
  let(:meta) { { meta: build(:meta) } }
  let(:list) { {}.merge(databases).merge(meta).with_indifferent_access }
  let(:database_instance) { Quandl::Database.new(database[:database]) }

  before(:all) do
    stub_request(:any, %r{https://www.quandl.com/api/v3.*})
  end

  describe 'get a single database' do
    before(:each) do
      expect(Quandl::Connection).to receive(:request).with(:get, 'databases/NSE', {}).and_return([{}, database])
      @database = Quandl::Database.get('NSE')
    end

    it 'database_code exists' do
      expect(@database.database_code).not_to be_nil
    end

    it 'returned value is a Quandl::Database' do
      expect(@database).to be_kind_of(Quandl::Database)
    end
  end

  describe 'Database methods' do
    context 'datasets' do
      it 'calls Quandl::Dataset.all' do
        expect(Quandl::Dataset).to receive(:all).with(params: { database_code: 'NSE', query: nil, page: 1 })
        database_instance.datasets
      end

      it 'calls Quandl::Dataset.all with passed in query params' do
        expect(Quandl::Dataset).to receive(:all).with(params: { database_code: 'NSE', query: 'foo', page: 2 })
        database_instance.datasets(params: { query: 'foo', page: 2 })
      end
    end

    context 'bulk_download_url' do
      before(:each) do
        Quandl::ApiConfig.api_key = 'token'
        Quandl::ApiConfig.api_version = '2015-04-09'
      end
      it 'constructs the url' do
        expect(database_instance.bulk_download_url(params: { download_type: 'partial' }))
          .to eq("https://www.quandl.com/api/v3/databases/#{database[:database][:database_code]}/data?api_key=token&api_version=2015-04-09&download_type=partial")
      end
    end

    context 'bulk_download_to_file' do
      before(:each) do
        Quandl::ApiConfig.api_key = 'token'
        Quandl::ApiConfig.api_version = nil
        stub_request(:any, %r{https://www.quandl.com/.*}).to_return(headers: { 'Location' => 'https://www.blah.com/download/database' }, status: 302)
      end

      context 'without filepath' do
        it 'raises error' do
          expect { database_instance.bulk_download_to_file(nil) }.to raise_error(Quandl::QuandlError, 'You must specific a file handle or folder to write to.')
        end
      end

      context 'without 302 return' do
        before(:each) do
          stub_request(:any, %r{https://www.quandl.com/.*}).to_return(status: 403)
        end

        it 'raises error' do
          expect { database_instance.bulk_download_to_file('.') }.to raise_error(Quandl::QuandlError)
        end
      end

      context 'with 302 return' do
        it 'parses download url from header and download file' do
          expect(database_instance).to receive(:bulk_download_path).and_return('/download')
          http = Net::HTTP.new('www.blah.com', 443)
          file_object = double('file')
          expect(File).to receive(:open).and_return(file_object)
          expect(file_object).to receive(:close)
          expect(file_object).to receive(:path)
          expect(http).to receive(:request_get)
          expect(Net::HTTP).to receive(:new).with('www.quandl.com', 443).and_call_original
          expect(Net::HTTP).to receive(:new).with('www.blah.com', 443).and_return(http)
          database_instance.bulk_download_to_file('.', params: { download_type: 'partial' })
        end
      end
    end
  end

  describe 'list' do
    before(:each) do
      expect(Quandl::Connection).to receive(:request).with(:get, 'databases/', {}).and_return([{}, list])
      @results = Quandl::Database.all
    end

    it 'elements are of class Quandl::Database' do
      expect(@results.first).to be_kind_of(Quandl::Database)
    end

    it 'contains meta' do
      expect(@results.meta).to_not be_nil
    end

    it 'databases with expected ids' do
      expect(@results.count).to eq(10)
      expect(@results.values.map(&:id)).to match_array(databases[:databases].map { |x| x[:id] })
    end

    it 'has more results' do
      expect(@results.more_results?).to eq(true)
    end
  end
end
