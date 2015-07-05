require 'pricing_service/price_cache'

module PricingService

class PricingEngine
  def self.with_cache(db)
    new(PriceCache.new(db))
  end

  def initialize(price_cache)
    @price_cache = price_cache
  end

  def price_for(sku)
    @price_cache.fetch_price_for_sku_or_generate_with(sku) { a_random_price }
  end
  def a_random_price
    # between 1.50 and 101.50
    cents = rand(10000) + 150 
    BigDecimal.new(cents)/100
  end
end

end
