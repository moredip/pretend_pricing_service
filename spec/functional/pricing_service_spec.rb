require 'functional_spec_helper'

describe PricingService do
  it "returns a price for a sweater" do
    uri = URI.parse(BASE_URL + '/price/sweater')
    response = Net::HTTP.get_response(uri)
    expect(response.body).to start_with '{"sku":"sweater"'
  end
end
