class Merchant::DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @next_three_holidays = NagerAPI.upcoming_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find_by(pct_discount: params[:pct_discount], threshold: params[:threshold])
    # discount = Discount.new(discount_params)

    if discount.nil?
      merchant.discounts.create(discount_params)
      redirect_to "/merchants/#{merchant.id}/discounts"
    else
      flash[:notice] = 'You already have this bulk discount. Please fill in again.'
      redirect_to "/merchants/#{merchant.id}/discounts/new"
    end
  end

  def destroy
    # merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:delete_discount])
    discount.destroy
    redirect_to "/merchants/#{params[:merchant_id]}/discounts"
  end

  private

  def discount_params
    params.permit(
      :pct_discount,
      :threshold
    )
  end
end
