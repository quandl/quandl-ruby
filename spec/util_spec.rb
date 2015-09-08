require 'spec_helper'

describe 'Util' do
  describe 'methodize' do
    it 'creates method friendly string' do
      expect(Quandl::Util.methodize('Hello World...Foo-Bar')).to eq('hello_worldfoo_bar')
    end
  end

  describe 'convert_to_dates' do
    let(:date) { Date.new(2015, 4, 9) }
    let(:date_time) { DateTime.now }
    let(:hash) do
      {
        date.to_s => {
          date.to_s => [date.to_s],
          date_time.to_s => date.to_s
        }
      }
    end

    let(:expected_results) do
      {
        date => {
          date => [date],
          date_time => date
        }
      }
    end

    it 'converts to dates and datetimes' do
      results = Quandl::Util.convert_to_dates(hash)
      expect(results[date.to_s][date_time.to_s]).to eq(date)
    end
  end

  describe 'constructed_path' do
    let(:path) { '/hello/:foo/world/:id' }
    let(:params) { { foo: 'bar', id: 1, another: 'a' } }

    it 'inserts params into path when param key matches' do
      results = Quandl::Util.constructed_path(path, params)
      expect(results).to eq('/hello/bar/world/1')
      expect(params.keys).to eq([:another])
    end
  end
end
