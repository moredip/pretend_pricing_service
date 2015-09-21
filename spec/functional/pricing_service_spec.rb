require 'spec_helper'
require 'net/http'

BASE_SERVICE_URI = "http://#{ENV['APP_NAME']}.cfapps.io/"

describe PricingService do
  it "returns a price for a sweater" do
    uri = URI.parse(BASE_SERVICE_URI + 'price/sweater')
    response = Net::HTTP.get_response(uri)
    expect(response.body).to start_with '{"sku":"sweater"'
  end
end
