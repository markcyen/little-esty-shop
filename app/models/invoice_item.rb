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

  def find_discount
    discounts
      .where('threshold <= ?', quantity)
      .order('discounts.pct_discount')
      # .pluck('pct_discount')
      .last
  end

  def discounted_price_calculation
    if find_discount != nil
      ((quantity * unit_price.to_f) / 100) * (1 - find_discount.pct_discount)
    else
      (quantity * unit_price.to_f) / 100
    end
  end

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
