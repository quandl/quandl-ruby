require 'spec_helper'

describe 'Data' do
  let(:dataset) { build(:dataset, database_code: 'NSE', dataset_code: 'OIL').with_indifferent_access }
  let(:dataset_data) { { dataset_data: build(:dataset_data) }.with_indifferent_access }
  let(:bad_dataset_data) do
    d = { dataset_data: build(:dataset_data) }.with_indifferent_access
    d[:dataset_data][:column_names].pop
    d
  end
  let(:data) do
    data = dataset_data[:dataset_data][:data]
    data.map! { |x| [Date.parse(x[0])] + x[1..-1] }
    data
  end

  before(:all) do
    stub_request(:any, %r{https://www.quandl.com/api/v3.*})
  end

  describe 'data list returns bad data' do
    before(:each) do
      expect(Quandl::Connection).to receive(:request).with(:get, 'datasets/NSE/OIL/data', params: {}).and_return([{}, bad_dataset_data])
    end

    it 'raises InvalidDataError' do
      expect { Quandl::Data.all(params: { database_code: dataset[:database_code], dataset_code: dataset[:dataset_code] }) }.to raise_error(Quandl::InvalidDataError)
    end
  end

  describe 'list' do
    before(:each) do
      expect(Quandl::Connection).to receive(:request).with(:get, 'datasets/NSE/OIL/data', params: {}).and_return([{}, dataset_data])
      @dataset_data = Quandl::Data.all(params: { database_code: dataset[:database_code], dataset_code: dataset[:dataset_code] })
    end

    it 'elements are of type Quandl::Data' do
      expect(@dataset_data.first).to be_a(Quandl::Data)
    end

    it 'list of values exists' do
      expect(@dataset_data.values).not_to be_nil
    end

    it 'gets column names' do
      expect(@dataset_data.column_names).to match_array(['Date', 'column.1', 'column.2'])
    end

    it 'can create array' do
      data = @dataset_data.to_a
      expect(data.size).to eq(3)
      expect(data.first.first).to be_a(Date)
      expect(data[0]).to match_array(data[0])
      expect(data[1]).to match_array(data[1])
      expect(data[2]).to match_array(data[2])
    end

    it 'can create csv' do
      expect(@dataset_data.to_csv).to eq("Date,column.1,column.2\n2015-07-15,440.0,2\n2015-07-14,437.5,3\n2015-07-13,433.3,4\n")
    end

    it 'has more results' do
      expect { @dataset_data.more_results? }.to raise_error(Quandl::QuandlError)
    end
  end
end
