require 'functional_spec_helper'

BASE_SERVICE_URI = "http://#{APP_NAME}.cfapps.io/"

describe PricingService do
  it "returns a price for a sweater" do
    uri = URI.parse(BASE_SERVICE_URI + 'price/sweater')
    response = Net::HTTP.get_response(uri)
    expect(response.body).to start_with '{"sku":"swererweater"'
  end
end
