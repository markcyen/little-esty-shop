require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    [:name, :description, :unit_price].each do |attribute|
      it {should validate_presence_of(attribute)}
    end

    it {should validate_numericality_of :unit_price}
    it {should belong_to :merchant}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
  end
end
