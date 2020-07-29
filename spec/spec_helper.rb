$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'quandl'
require 'factory_girl'
require 'webmock/rspec'
require 'active_support/core_ext/hash/indifferent_access'

factory_dir = File.join(File.dirname(__FILE__), 'factories/**/*.rb')
# rubocop:disable Lint/NonDeterministicRequireOrder
Dir.glob(factory_dir).each do |f|
  require(f)
end
# rubocop:enable Lint/NonDeterministicRequireOrder

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
