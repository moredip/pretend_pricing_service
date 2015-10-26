require 'spec_helper'
require 'rake'
require 'net/http'

load File.expand_path("Rakefile")

NAMESPACE = ENV["NAMESPACE"] || SecureRandom.hex(4)
MANAGE_DEPLOYED_APP = ENV["BASE_URL"]
BASE_URL = ENV["BASE_URL"] || "http://pricing-#{NAMESPACE}.cfapps.io"

raise "You need to have the NAMESPACE or the BASE_URL environment variable set to run these tests" unless ENV["NAMESPACE"] || ENV["BASE_URL"]

RSpec.configure do |rspec|
  rspec.before(:suite) do
    Rake::Task["cf:deploy"].invoke(ENV['RACK_ENV'], NAMESPACE) unless MANAGE_DEPLOYED_APP
  end

  rspec.after(:suite) do
    Rake::Task["cf:delete"].invoke(ENV['RACK_ENV'], NAMESPACE) unless MANAGE_DEPLOYED_APP
  end
end
