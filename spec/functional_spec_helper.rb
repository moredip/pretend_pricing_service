require 'spec_helper'
require 'rake'
require 'net/http'

load File.expand_path("Rakefile")

PREFIX = ENV["PREFIX"] || SecureRandom.hex(4)
MANAGE_DEPLOYED_APP = ENV["BASE_URL"]
BASE_URL = ENV["BASE_URL"] || "http://#{PREFIX}-pricing.cfapps.io"

raise "You need to have the PREFIX or the BASE_URL environment variable set to run these tests" unless ENV["PREFIX"] || ENV["BASE_URL"]

RSpec.configure do |rspec|
  rspec.before(:suite) do
    Rake::Task["cf:deploy"].invoke(ENV['RACK_ENV'], PREFIX) unless MANAGE_DEPLOYED_APP
  end

  rspec.after(:suite) do
    Rake::Task["cf:delete"].invoke(ENV['RACK_ENV'], PREFIX) unless MANAGE_DEPLOYED_APP
  end
end
