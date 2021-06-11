class Merchant::DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @next_three_holidays = NagerAPI.upcoming_holidays
  end
end
