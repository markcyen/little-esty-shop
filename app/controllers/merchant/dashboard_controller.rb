class Merchant::DashboardController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @top_5_customers_array = @merchant.top_5_customers
    @customers = Customer.all
    @items = @merchant.items
    @ready_to_ship_items = @merchant.ready_to_ship
  end
end
