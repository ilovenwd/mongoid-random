gem 'minitest'

require 'mini_shoulda'
require 'minitest/autorun'
require 'turn'
require 'spork'
require 'mongoid'
require 'mongoid-random'

Mongoid.configure do |config|
  database = Mongo::Connection.new.db("mongoid-random_test")
  database.add_user("mongoid", "test")
  config.master = database
  config.logger = nil
end

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Spork.prefork do
end

Spork.each_run do
end

MiniTest::Spec.add_teardown_hook do
  Mongoid.purge!
end
