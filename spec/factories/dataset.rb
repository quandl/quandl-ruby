FactoryGirl.define do
  factory :dataset, class: Hash do
    sequence(:dataset_code) { |n| "DATASET_CODE#{n}" }
    sequence(:database_code) { |n| "DATASET_CODE#{n}" }
    name 'Benin: percentage of population'
    description 'Percentage of population'
    frequency 'daily'
    column_names ['Date', 'column.1', 'column.2']
    type 'Time Series'
    premium false
    sequence(:database_id)
    sequence(:id)
  end

  initialize_with { attributes }
end
