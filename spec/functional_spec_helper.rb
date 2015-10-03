require 'spec_helper'
require 'rake'
require 'net/http'

load File.expand_path("Rakefile")

PREFIX = ENV["PREFIX"] || SecureRandom.hex(4)
BASE_SERVICE_URI = "http://#{PREFIX}_pricing.cfapps.io/"

RSpec.configure do |rspec|
  rspec.before(:suite) do
    Rake::Task["app:deploy"].invoke(ENV['RACK_ENV'], PREFIX)
  end

  rspec.after(:suite) do
    Rake::Task["app:delete"].invoke(ENV['RACK_ENV'], PREFIX)
  end
end
