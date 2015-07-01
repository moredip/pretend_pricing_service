require 'grape'
require 'pricing_service/pricing_engine'

module PricingService
  class API < Grape::API
    format :json

    helpers do
      def pricing_engine
        PricingEngine.new
      end
    end

    get '/price/:sku' do
      sku = params[:sku]
      price = pricing_engine.price_for(sku)
      {
        sku: sku,
        price: price
      }
    end
  end
end
