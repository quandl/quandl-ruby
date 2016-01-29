require 'spec_helper'

describe 'Dataset' do
  let(:dataset) { { dataset: build(:dataset, database_code: 'NSE', dataset_code: 'OIL') }.with_indifferent_access }
  let(:datasets) { { datasets: build_list(:dataset, 2) } }
  let(:meta) { { meta: build(:meta, current_page: 1, total_pages: 1) } }
  let(:list) { {}.merge(datasets).merge(meta).with_indifferent_access }

  before(:all) do
    stub_request(:any, %r{https://www.quandl.com/api/v3.*})
  end

  describe 'get a single dataset' do
    before(:each) do
      expect(Quandl::Connection).to receive(:request).with(:get, 'datasets/NSE/OIL/metadata', {}).and_return([{}, dataset])
      @dataset = Quandl::Dataset.get('NSE/OIL')
    end

    it 'returned value is a Quandl::Dataset' do
      expect(@dataset).to be_a(Quandl::Dataset)
    end

    it 'return value has codes' do
      expect(@dataset.database_code).not_to be_nil
      expect(@dataset.dataset_code).not_to be_nil
    end

    it 'column names matches' do
      expect(@dataset.column_names).to match_array(['Date', 'column.1', 'column.2'])
    end
  end

  describe 'dataset methods' do
    context 'database' do
      it 'calls Quandl::Database.get' do
        expect(Quandl::Database).to receive(:get)
        Quandl::Dataset.new(dataset[:dataset]).database
      end
    end

    context 'data' do
      it 'calls Quandl::Data.all' do
        expect(Quandl::Data).to receive(:all).with(params: { database_code: 'NSE', dataset_code: 'OIL' })
        Quandl::Dataset.new(dataset[:dataset]).data
      end
    end
  end

  describe 'list' do
    before(:each) do
      expect(Quandl::Connection).to receive(:request).with(:get, 'datasets/', {}).and_return([{}, list])
      @results = Quandl::Dataset.all
    end

    it 'list contains Quandl::Dataset elements' do
      @results.each do |result|
        expect(result).to be_a(Quandl::Dataset)
      end
    end

    it 'has more results' do
      expect(@results.more_results?).to eq(false)
    end
  end
end
