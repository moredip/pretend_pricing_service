require 'grape'
require 'pry'
require 'sequel'
require 'dotenv'
Dotenv.load

ENV['RACK_ENV'] ||= 'test'

DB = Sequel.connect(ENV.fetch('DATABASE_URL'),max_connections:ENV.fetch('DB_POOL',5))

Dir.glob(File.expand_path('../../lib/**/*.rb', __FILE__)) {|file| require file}

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end
end
