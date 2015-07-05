module PricingService
  class PriceCache
    def initialize(db)
      @cache_table = db[:pricing_cache]
    end

    def fetch_price_for_sku_or_generate_with(sku,&generator_proc)
      cached_price = lookup_price(sku,bucketed_time)
      if cached_price
        logger.debug("found price in cache: #{cached_price}")
        cached_price
      else
        price = generator_proc.call
        logger.debug("generated and cached price: #{price}")
        store_price(sku,bucketed_time,price) 
        price
      end
    end

    private

    def store_price(sku,time,price)
      @cache_table.insert(sku:sku,timestamp:time,price:price)
    end

    def lookup_price(sku,time)
      cache_entry = @cache_table.first(sku:sku,timestamp:time)
      cache_entry and cache_entry[:price] or nil
    end

    def logger
      Grape::API.logger
    end

    BUCKET_SIZE_IN_SECONDS = 60.0
    def bucketed_time(time = Time.now)
      time_in_seconds = time.to_f
      bucketed_time_in_seconds = time_in_seconds - (time_in_seconds%BUCKET_SIZE_IN_SECONDS)
      Time.at(bucketed_time_in_seconds)
    end
  end
end
