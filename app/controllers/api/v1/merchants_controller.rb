class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Store.all)
    # render json: Merchant.all
  end
end
