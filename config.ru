$LOAD_PATH.unshift File.expand_path( "../lib", __FILE__ )

require 'microscope_tracer/rack_middleware'

require 'pricing_service/api'

ENV['RACK_ENV'] ||= "development"

if ENV['RACK_ENV'].downcase == 'development'
  $stdout.sync = true
  puts "running in DEV MODE!"
end

require 'sequel'
DB = Sequel.connect(ENV.fetch('DATABASE_URL'),max_connections:ENV.fetch('DB_POOL',5))

use MicroscopeTracer::RackMiddleware, "pricing-service"
run PricingService::API
