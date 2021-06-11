class Discount < ApplicationRecord
  validates_presence_of :pct_discount, :threshold
  validates_numericality_of :pct_discount
  validates_numericality_of :threshold, only_integer: true
  belongs_to :merchant
end
