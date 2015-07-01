$LOAD_PATH.unshift File.expand_path( "../lib", __FILE__ )

require 'pricing_service/api'

run PricingService::API
