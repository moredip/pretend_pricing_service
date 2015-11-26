$LOAD_PATH.unshift File.expand_path( "../lib", __FILE__ )

require 'microscope_tracer/rack_middleware'
require 'pricing_service/api'
require 'json'
require 'sequel'

ENV['RACK_ENV'] ||= "development"

if ENV['RACK_ENV'].downcase == 'development'
  $stdout.sync = true
  puts "running in DEV MODE!"
  db_url = ENV['DATABASE_URL']
  max_connections = ENV.fetch('DB_POOL', 5)
elsif JSON.parse(ENV['VCAP_SERVICES']).has_key?("elephantsql")
  db_credentials = JSON.parse(ENV['VCAP_SERVICES'])["elephantsql"][0]["credentials"]
  db_url = db_credentials["uri"]
  max_connections = db_credentials["max_conns"]
else
  db_credentials = JSON.parse(ENV['VCAP_SERVICES'])["p-mysql"][0]["credentials"]
  db_url = db_credentials["uri"]
  max_connections = 5
end

DB = Sequel.connect(db_url,max_connections:max_connections)

use MicroscopeTracer::RackMiddleware, "pricing-service"
run PricingService::API
