require 'spec_helper'
require 'rake'
require 'net/http'

load File.expand_path("Rakefile")

APP_NAME = ENV["APP_NAME"] || "pretend-pricing-service-#{SecureRandom.hex(4)}"

RSpec.configure do |rspec|
  rspec.before(:suite) do
    Rake::Task["app:deploy"].invoke(ENV['RACK_ENV'], APP_NAME, APP_NAME)
  end

  rspec.after(:suite) do
    Rake::Task["app:delete"].invoke(ENV['RACK_ENV'], APP_NAME)
  end
end
