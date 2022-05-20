class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
  @order = ...

  if @order.save
    render json: @order
  else
    render json: { message: "Validation failed", errors: @order.errors }, status: 400
  end
end

  def create
    new_item = Item.create(item_params)
    if new_item.valid?
      render json: ItemSerializer.new(new_item), status: 201
    else
      render json: { message: "Validation failed", errors: new_item.errors }, status: 422
    end
  end

  private
  def item_params
    params.require(:item).permit(:unit_price, :merchant_id, :name, :description)
  end
end
