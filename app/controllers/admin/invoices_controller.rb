class Admin::InvoicesController < ApplicationController
  before_action :load_data, only: [:show, :update]

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @all_invoice_items = @invoice.invoice_items
    @admin_discounted_revenue = @all_invoice_items.sum do |invoice_item|
      invoice_item.discounted_price_calculation
    end
  end

  def update
    @invoice.update(status: params[:status])
    @invoice.save!

    redirect_to "/admin/invoices/#{@invoice.id}"
  end

  private

  def load_data
    @invoice = Invoice.find(params[:id])
    @customer = Customer.find(@invoice.customer_id)
    @invoice_items = InvoiceItem.find_invoice_items(@invoice.id)
    @invoice_revenue = Invoice.expected_invoice_revenue(@invoice)[0].invoice_revenue.to_f / 100
  end
end
