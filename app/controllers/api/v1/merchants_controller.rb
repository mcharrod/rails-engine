class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
    # render json: Merchant.all
  end

  def show
  end 
end
