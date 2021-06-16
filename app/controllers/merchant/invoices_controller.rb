class Merchant::InvoicesController < ApplicationController
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:invoice_id])
    @items = @invoice.items
    @customer = Customer.where('id = ?', @invoice.customer_id).first
    @invoice_items = InvoiceItem.joins(item: :merchant).where('invoice_id = ?', @invoice.id).where('items.merchant_id = ?', @merchant.id)
    @total_revenue = @invoice_items.sum do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end
    @total_discounted_revenue = @invoice_items.sum do |invoice_item|
      invoice_item.discounted_price_calculation
    end

    if params[:status] != nil && params[:status] == 1
      InvoiceItem.where('merchant_id = ? AND invoice_id = ?', params[:merchant_id], params[:invoice_id]).first.update(status: 'Pending')
      redirect_to "/merchants/#{@merchant.id}/invoices/#{@invoice.id}"
    elsif params[:status] != nil && params[:status] == 2
      InvoiceItem.where('merchant_id = ? AND invoice_id = ?', params[:merchant_id], params[:invoice_id]).first.update(status: 'Packaged')
      redirect_to "/merchants/#{@merchant.id}/invoices/#{@invoice.id}"
    elsif params[:status] != nil && params[:status] == 3
      InvoiceItem.where('merchant_id = ? AND invoice_id = ?', params[:merchant_id], params[:invoice_id]).first.update(status: 'Shipped')
      redirect_to "/merchants/#{@merchant.id}/invoices/#{@invoice.id}"
    end
  end

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    @item_ids = Merchant.find(params[:merchant_id]).items.pluck(:id)
    @invoices = @merchant.invoices.uniq
  end

  def update_status
    merchant = Merchant.find(params[:merchant_id])
    invoice = Invoice.find(params[:invoice_id])
    item = InvoiceItem.find(params[:item_id])

    item.update(status: params[:status])

    redirect_to "/merchants/#{merchant.id}/invoices/#{invoice.id}"
  end
end
