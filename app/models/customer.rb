class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices

  def self.top_five_by_transaction_success
    joins(invoices: :transactions)
    .group(:id).where('transactions.result = ?', 0)
    .select('customers.*, count(transactions.id) as number_of_transactions')
    .order(number_of_transactions: :desc)
    .limit(5)
  end

end
