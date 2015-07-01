$LOAD_PATH.unshift File.expand_path( "../lib", __FILE__ )

require 'pricing_service/api'

if ENV['RACK_ENV'].downcase == 'development'
  $stdout.sync = true
  puts "running in DEV MODE!"
end

run PricingService::API
