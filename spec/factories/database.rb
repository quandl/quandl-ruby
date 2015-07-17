FactoryGirl.define do
  factory :database, class: Hash do
    sequence(:database_code) { |n| "DATASET_CODE#{n}" }
    name 'Benin: percentage of population'
    description 'Percentage of population'
    datasets_count 1
    downloads ['Date', 'Column 1', 'Column 2']
    premium true
    image ''
    sequence(:id)
  end

  initialize_with { attributes }
end
