class InvoiceItem < ApplicationRecord
  validates :quantity, presence: true, numericality: true
  validates :unit_price, presence: true, numericality: true
  validates_presence_of :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant
  has_many :transactions, through: :invoice
  has_one :customer, through: :invoice

  enum status: ['pending', 'packaged', 'shipped']

  def find_pct_discount
    discounts
      .where('threshold <= ?', quantity)
      .order('pct_discount')
      .pluck('pct_discount')
      .last
  end

  def discounted_price_calculation
    if find_pct_discount != nil
      ((quantity * unit_price.to_f) / 100) * (1 - find_pct_discount)
    else
      (quantity * unit_price.to_f) / 100
    end
  end

# InvoiceItem.joins(:discounts, :transactions, item: :merchant).select('invoice_items.invoice_id, invoice_items.item_id, invoice_items.unit_price, sum(invoice_items.quantity) AS quantity_count, discounts.threshold, sum(invoice_items.quantity * invoice_items.unit_price) AS total_item_revenue_per_invoice').group(:invoice_id, :item_id, :unit_price, 'discounts.threshold').where('invoice_items.invoice_id = ?', 484).where('transactions.result = ?', 0).where('items.merchant_id = ?', 1)
# InvoiceItem.joins(:discounts, :transactions, item: :merchant).select('invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price, discounts.threshold, sum(invoice_items.quantity * invoice_items.unit_price) AS total_item_revenue_per_invoice').group(:invoice_id, :item_id, :quantity, :unit_price, 'discounts.threshold').where('invoice_items.invoice_id = ?', 484).where('transactions.result = ?', 0).where('items.merchant_id = ?', 1).order('invoice_items.item_id')

# InvoiceItem.joins(:transactions, item: :merchant, invoice: :customer).select('invoice_items.invoice_id, invoice_items.item_id, invoice_items.unit_price, invoice_items.quantity, sum(invoice_items.quantity * invoice_items.unit_price) AS total_item_revenue_per_invoice, invoices.customer_id').group(:invoice_id, :item_id, :unit_price, 'invoice_items.quantity', 'invoices.customer_id').where('invoice_items.invoice_id = ?', 484).where('transactions.result = ?', 0).where('items.merchant_id = ?', 1)
# InvoiceItem.joins(:transactions, item: :merchant, invoice: :customer).select('invoice_items.invoice_id, invoice_items.item_id, invoice_items.unit_price, invoice_items.quantity, invoice_items.updated_at, sum(invoice_items.quantity * invoice_items.unit_price) AS total_item_revenue_per_invoice, invoices.customer_id').distinct.group('invoice_items.invoice_id, invoice_items.item_id, invoice_items.unit_price, invoice_items.quantity, invoice_items.updated_at, invoices.customer_id').where('invoice_items.invoice_id = ?', 484).where('transactions.result = ?', 0).where('items.merchant_id = ?', 1)

# .where('invoice_items.item_id = ?', 10)

    # gives me a merchant's revenue for just an item (including quantity) of one invoice
  # def each_invoice_item_revenue(invoice_id, item_id, merchant_id)
  #   self.joins(:transactions, item: :merchant)
  #     .select(
  #       'invoice_items.invoice_id,
  #       invoice_items.item_id,
  #       invoice_items.unit_price,
  #       sum(invoice_items.quantity) AS quantity_count,
  #       sum(invoice_items.quantity * invoice_items.unit_price) AS total_item_revenue_per_invoice'
  #     )
  #     .group(:invoice_id, :item_id, :unit_price)
  #     .where('invoice_items.invoice_id = ?', invoice_id)
  #     .where('invoice_items.item_id = ?', item_id)
  #     .where('items.merchant_id = ?', merchant_id)
  #     .where('transactions.result = ?', 0)
  # end

# InvoiceItem.joins(:discounts).select('discounts.*, invoice_items.item_id, invoice_items.quantity').group('invoice_items.item_id').order(:discounts).where('discounts.threshold <= ?', invoice_items.quantity).last

    # discounts (threshold, percent discount)
    # invoice_items (quantity - sum up item quantity)
    # compare discounts.threshold to sum(invoice_items.quantity) for specific item
# InvoiceItem.joins(:discounts).select('invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price, discounts.*').group('invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price, discounts.id').where('discounts.threshold <= 10').where('invoice_items.quantity = 10').where('invoice_items.item_id = 10').where('invoice_items.invoice_id = 484').order(:discounts).last
# InvoiceItem.joins(:discounts, item: :merchant).select('invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price, discounts.*').group('invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price, discounts.id').where('items.merchant_id = 1').where('invoice_items.invoice_id = 484').where('discounts.threshold <= 10').where('invoice_items.quantity = 10').order(:discounts).last
# invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity, invoice_items.unit_price

# InvoiceItem.joins(:discounts).select('discounts.*,invoice_items.invoice_id,invoice_items.item_id,invoice_items.quantity,sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue').group('discounts.id, invoice_items.invoice_id, invoice_items.item_id, invoice_items.quantity').where('discounts.threshold <= invoice_items.quantity').order('discounts.threshold')

  # def self.apply_discounts(merchant_id, invoice_id)
  #   joins(:discounts, item: :merchant)
  #     .select(
  #       'invoice_items.invoice_id,
  #       invoice_items.item_id,
  #       invoice_items.quantity,
  #       invoice_items.unit_price,
  #       discounts.*'
  #     )
  #     .group(
  #       'invoice_items.invoice_id,
  #       invoice_items.item_id,
  #       invoice_items.quantity,
  #       invoice_items.unit_price,
  #       discounts.id'
  #     )
  #     .where('invoice_items.invoice_id = ?', invoice_id)
  #     .where('invoice_items.quantity >= ?', 'discounts.threshold')
  #     .where('items.merchant_id = ?', merchant_id)
  #     .order('discounts.threshold')
  # end

  # def discounted_revenue(invoice_id)
  #   binding.pry
  #   if apply_discount(invoice_id) != nil?
  #     apply_discount(invoice_id).quantity * apply_discount(invoice_id).unit_price * (1 - apply_discount(invoice_id).pct_discount)
  #   else
  #     apply_discount(invoice_id).quantity * apply_discount(invoice_id).unit_price
  #   end
  # end

  # def discounted_revenue
  #   if apply_discount.present?
  #     quantity * unit_price * (1 - apply_discount.pct_discount)
  #   else
  #     quantity * unit_price
  #   end
  # end

  # def pluck_discount_threshold
  #   discounts.select('discounts.*')
  #     .distinct
  #     .pluck(:threshold)
  # end
  #
  # def pluck_discount_percentage
  #   discounts.select('discounts.*')
  #   .distinct
  #   .pluck(:pct_discount)
  # end
  #
  # def each_item_discount_revenue(invoice_id, item_id)
  #   each_invoice_item_revenue(invoice_id, item_id).sum do |invoice_item|
  #     pluck_discount_threshold.each do |threshold|
  #       if invoice_items.quantity_count < min(pluck_discount_threshold)
  #         total_item_revenue_per_invoice
  #       elsif invoice_items.quantity_count
  #       end
  #     end
  #   end
  # end

  def self.find_invoice_items(params)
    joins(:item)
      .select('items.*, invoice_items.invoice_id, invoice_items.status, invoice_items.quantity')
      .where('invoice_id = ?', params)
  end

  def convert_to_dollar
    if unit_price.nil?
      0
    else
      unit_price.to_f / 100
    end
  end
end
#
# def apply_discount
#   discounts
#     .where('discounts.threshold <= ?', quantity)
#     .order('discounts.pct_discount DESC')
#     .first
# end
#
# def total_price
#   quantity * unit_price
# end
#
# def discounted_price
#   if apply_discount != nil
#     total_price * (1 - apply_discount.pct_discount)
#   else
#     total_price
#   end
# end

# InvoiceItem.joins(:item).select('items.*, invoice_items.*').where('invoice_id = ?', params)

# Query_1
# SELECT items.*, invoice_items.* FROM "invoice_items" INNER JOIN "items" ON "items"."id" = "invoice_items"."item_id" WHERE (invoice_id = 9)
#
# Query_2
# SELECT invoice_items.*, items.* FROM "invoice_items" INNER JOIN "items" ON "items"."id" = "invoice_items"."item_id" WHERE (invoice_id = 9)
