module PricingService

class PricingEngine
  def price_for(sku)
    price = (rand*40).round(2) +10
    price
  end
end

end
