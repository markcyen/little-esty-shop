require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it {should validate_presence_of :quantity}
    it {should validate_numericality_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of :unit_price}
    it {should validate_presence_of :status}
  end

  describe "relationships" do
    it {should belong_to :invoice}
    it {should belong_to :item}
    it {should have_many(:transactions).through(:invoice)}
  end

  describe 'methods from group project' do
    before(:each) do
      @customer_1  = Customer.create!(first_name: 'Tanya', last_name: 'Tiger')
      @invoice_1 = @customer_1.invoices.create!(status: 0)
      @invoice_2 = @customer_1.invoices.create!(status: 1)
      @invoice_3 = @customer_1.invoices.create!(status: 1)
      @invoice_4 = @customer_1.invoices.create!(status: 2)
      @invoice_5 = @customer_1.invoices.create!(status: 0)

      @merchant_1 = Merchant.create!(name: 'Roald')
      @item_1 = @merchant_1.items.create!(name: 'Doritos', description: 'Delicious', unit_price: 39434)
      @item_2 = @merchant_1.items.create!(name: 'Lays', description: 'Deliciouio', unit_price: 8356)
      @item_3 = @merchant_1.items.create!(name: 'Cadlee', description: 'Perfecto', unit_price: 9064)

      InvoiceItem.create!(invoice: @invoice_1, item: @item_1, status: 0, quantity: 200, unit_price: 39434)
      InvoiceItem.create!(invoice: @invoice_1, item: @item_2, status: 1, quantity: 295, unit_price: 8356)
      InvoiceItem.create!(invoice: @invoice_1, item: @item_3, status: 2, quantity: 382, unit_price: 9064)
      InvoiceItem.create!(invoice: @invoice_4, item: @item_1, status: 2, quantity: 130, unit_price: 39434)
      InvoiceItem.create!(invoice: @invoice_5, item: @item_1, status: 1, quantity: 97, unit_price: 39434)
    end

    describe '.find_invoice_items' do
      it 'finds invoice items based on invoice id' do
        expect(InvoiceItem.find_invoice_items(@invoice_1)[0].invoice_id).to eq(@invoice_1.id)
        expect(InvoiceItem.find_invoice_items(@invoice_1)).to_not include(@invoice_4.id)
      end
    end

    describe '#convert_to_dollar' do
      it 'converts unit_price integer to float dollar' do
        @check_first_invoice_item = InvoiceItem.find_invoice_items(@invoice_1).first
        expect(@check_first_invoice_item.convert_to_dollar).to eq(394.34)
      end
    end
  end

  describe 'methods for the solo final' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Regina's Ragin' Ragdolls")
      @merchant_2 = Merchant.create!(name: "Mark's Money Makin' Markers")

      @discount_1 = @merchant_1.discounts.create!(pct_discount: 0.10, threshold: 25)
      @discount_2 = @merchant_1.discounts.create!(pct_discount: 0.20, threshold: 50)

      @item_1 = @merchant_1.items.create!(name: "Twinkies", description: "Yummy", unit_price: 400)
      @item_2 = @merchant_1.items.create!(name: "Applesauce", description: "Yummy in my tummy", unit_price: 340)
      @item_3 = @merchant_2.items.create!(name: "Milk", description: "Delicious", unit_price: 400)
      @item_4 = @merchant_2.items.create!(name: "Bread", description: "So soft", unit_price: 340)

      @customer_1 = Customer.create!(first_name: "Rita", last_name: "Last Name")

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 0)
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 1)
      @invoice_3 = Invoice.create!(customer_id: @customer_1.id, status: 1)
      @invoice_4 = Invoice.create!(customer_id: @customer_1.id, status: 1)

      # Scenario 1
      @invoice_item_1 = InvoiceItem.create!(item: @item_1, invoice: @invoice_1, quantity: 24, unit_price: 400, status: 1)
      @invoice_item_2 = InvoiceItem.create!(item: @item_2, invoice: @invoice_1, quantity: 19, unit_price: 340, status: 0)

      # Scenario 2
      @invoice_item_3 = InvoiceItem.create!(item: @item_1, invoice: @invoice_2, quantity: 26, unit_price: 400, status: 1)
      @invoice_item_4 = InvoiceItem.create!(item: @item_2, invoice: @invoice_2, quantity: 19, unit_price: 340, status: 1)

      # Scenario 3
      @invoice_item_5 = InvoiceItem.create!(item: @item_1, invoice: @invoice_3, quantity: 25, unit_price: 400, status: 1)
      @invoice_item_6 = InvoiceItem.create!(item: @item_2, invoice: @invoice_3, quantity: 50, unit_price: 340, status: 1)

      # Scenario 4
      @invoice_item_7 = InvoiceItem.create!(item: @item_1, invoice: @invoice_4, quantity: 51, unit_price: 400, status: 1)
      @invoice_item_8 = InvoiceItem.create!(item: @item_2, invoice: @invoice_4, quantity: 50, unit_price: 340, status: 1)

      # Scenario 5
      @invoice_item_9 = InvoiceItem.create!(item: @item_1, invoice: @invoice_4, quantity: 25, unit_price: 400, status: 1)
      @invoice_item_10 = InvoiceItem.create!(item: @item_2, invoice: @invoice_4, quantity: 50, unit_price: 340, status: 1)
      @invoice_item_11 = InvoiceItem.create!(item: @item_3, invoice: @invoice_4, quantity: 25, unit_price: 400, status: 1)
      @invoice_item_12 = InvoiceItem.create!(item: @item_4, invoice: @invoice_4, quantity: 50, unit_price: 340, status: 1)

      Transaction.create!(invoice_id: @invoice_1.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_2.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_3.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_4.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
    end

    describe '#find_pct_discount' do
      it 'finds the best percent discount by passing discount quantity threshold' do
        expect(@invoice_item_1.find_pct_discount).to eq(nil)
        expect(@invoice_item_2.find_pct_discount).to eq(nil)
        expect(@invoice_item_3.find_pct_discount).to eq(0.1)
        expect(@invoice_item_4.find_pct_discount).to eq(nil)
        expect(@invoice_item_5.find_pct_discount).to eq(0.1)
        expect(@invoice_item_6.find_pct_discount).to eq(0.2)
      end
    end

    describe '#discounted_price_calculation' do
      it 'calculates the discounted price only if item quantity meets threshold' do

        expect(@invoice_item_1.discounted_price_calculation.to_f).to eq(96.0)
        expect(@invoice_item_3.discounted_price_calculation.to_f).to eq(93.6)
      end

      it 'calculates the discounted price for the best discount' do

        expect(@invoice_item_7.discounted_price_calculation.to_f).to eq(163.2)
        expect(@invoice_item_7.discounted_price_calculation.to_f).to_not eq(183.6)
        expect(@invoice_item_7.discounted_price_calculation.to_f).to_not eq(204.0)
        expect(@invoice_item_8.discounted_price_calculation.to_f).to eq(136.0)
        expect(@invoice_item_8.discounted_price_calculation.to_f).to_not eq(153.0)
        expect(@invoice_item_8.discounted_price_calculation.to_f).to_not eq(170.0)
      end
    end
  end

end
