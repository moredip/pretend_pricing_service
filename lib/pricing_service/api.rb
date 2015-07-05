require 'grape'
require 'pricing_service/pricing_engine'

module PricingService
  class API < Grape::API
    format :json

    helpers do
      def pricing_engine
        PricingEngine.with_cache(DB)
      end
    end

    get '/price/:sku' do
      sku = params[:sku]
      price = "%01.2f" % pricing_engine.price_for(sku)
      {
        sku: sku,
        price: price
      }
    end
  end
end
