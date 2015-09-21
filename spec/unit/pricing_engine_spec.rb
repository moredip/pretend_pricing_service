require 'spec_helper'

describe PricingService::PricingEngine do
  subject { PricingService::PricingEngine.with_cache(DB) }

  it "saves a price for an sku and will return it repeatedly" do
    price = subject.price_for("1234")
    expect(subject.price_for("1234")).to eq(price)
  end
end
