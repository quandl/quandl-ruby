$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'quandl'
require 'factory_girl'
require 'pry-byebug'
require 'webmock/rspec'
require 'active_support/core_ext/hash/indifferent_access'

factory_dir = File.join(File.dirname(__FILE__), 'factories/**/*.rb')
Dir.glob(factory_dir).each do |f|
  require(f)
  puts f
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
