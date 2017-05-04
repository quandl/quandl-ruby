require 'spec_helper'

describe 'ModelBase' do
  let(:hash) { { 'foo' => 'bar', 'here' => 1 } }
  let(:model) { Quandl::ModelBase.new(hash) }

  it 'converts data fields' do
    expect(model.data_fields).to eq(%w[foo here])
  end

  it 'column names titelizes' do
    expect(model.column_names).to eq(%w[Foo Here])
  end

  it 'converts to array' do
    expect(model.to_a).to eq(['bar', 1])
  end
end
