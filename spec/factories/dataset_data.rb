FactoryGirl.define do
  factory :dataset_data, class: Hash do
    column_names ['Date', 'column.1', 'column.2']
    data [['2015-07-15', 440.0, 2], ['2015-07-14', 437.5, 3], ['2015-07-13', 433.3, 4]]
  end

  initialize_with { attributes }
end
