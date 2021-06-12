require 'rails_helper'

RSpec.describe Discount, type: :feature do
  describe "Discount Index Page" do
    before :each do
      @merchant_1 = Merchant.create!(name: "Regina's Ragin' Ragdolls")
      @merchant_2 = Merchant.create!(name: "Mark's Money Makin' Markers")
      @merchant_3 = Merchant.create!(name: "Caleb's California Catapults")

      @discount_1 = @merchant_1.discounts.create!(pct_discount: 0.10, threshold: 10)
      @discount_2 = @merchant_1.discounts.create!(pct_discount: 0.20, threshold: 15)
      @discount_3 = @merchant_1.discounts.create!(pct_discount: 0.30, threshold: 20)

      @discount_4 = @merchant_2.discounts.create!(pct_discount: 0.05, threshold: 5)
      @discount_5 = @merchant_2.discounts.create!(pct_discount: 0.15, threshold: 10)
      @discount_6 = @merchant_2.discounts.create!(pct_discount: 0.25, threshold: 20)

      @item_1 = @merchant_1.items.create!(name: "Twinkies", description: "Yummy", unit_price: 400)
      @item_2 = @merchant_1.items.create!(name: "Applesauce", description: "Yummy in my tummy", unit_price: 340)
      @item_3 = @merchant_1.items.create!(name: "Milk", description: "Delicious", unit_price: 493)
      @item_4 = @merchant_1.items.create!(name: "Bread", description: "So soft", unit_price: 837)
      @item_5 = @merchant_1.items.create!(name: "Ice Cream", description: "So smooth", unit_price: 293)
      @item_6 = @merchant_1.items.create!(name: "Waffles", description: "So moist", unit_price: 938)
      @item_7 = @merchant_2.items.create!(name: "Desk", description: "So square", unit_price: 467)
      @item_8 = @merchant_2.items.create!(name: "Desk Chair", description: "So comfy", unit_price: 500)
      @item_9 = @merchant_2.items.create!(name: "100 pack Pens", description: "So useful", unit_price: 824)
      @item_10 = @merchant_2.items.create!(name: "Printer Paper", description: "Who uses this?", unit_price: 1203)
      @item_11 = @merchant_2.items.create!(name: "50 Pack Markers", description: "Draw", unit_price: 534)

      @customer_1 = Customer.create!(first_name: "Regina", last_name: "Last Name")
      @customer_2 = Customer.create!(first_name: "Jennifer", last_name: "Last Name")
      @customer_3 = Customer.create!(first_name: "Mark", last_name: "Last Name")
      @customer_4 = Customer.create!(first_name: "Caleb", last_name: "Last Name")
      @customer_5 = Customer.create!(first_name: "Richard", last_name: "Last Name")
      @customer_6 = Customer.create!(first_name: "Zach", last_name: "Last Name")

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 0)
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_3 = Invoice.create!(customer_id: @customer_3.id, status: 1)
      @invoice_4 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_5.id, status: 0)
      @invoice_6 = Invoice.create!(customer_id: @customer_6.id, status: 0)
      @invoice_7 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_8 = Invoice.create!(customer_id: @customer_3.id, status: 1)
      @invoice_9 = Invoice.create!(customer_id: @customer_4.id, status: 1)
      @invoice_10 = Invoice.create!(customer_id: @customer_5.id, status: 0)
      @invoice_11 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 400, status: 1)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 13, unit_price: 340, status: 0)
      InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 43, unit_price: 493, status: 2)
      InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 5, unit_price: 837, status: 1)
      InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_5.id, quantity: 9, unit_price: 293, status: 1)
      InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_5.id, quantity: 23, unit_price: 938, status: 2)
      InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 3, unit_price: 400, status: 0)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_6.id, quantity: 15, unit_price: 340, status: 1)
      InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_6.id, quantity: 23, unit_price: 493, status: 0)
      InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_7.id, quantity: 1, unit_price: 467, status: 1)
      InvoiceItem.create!(item_id: @item_8.id, invoice_id: @invoice_8.id, quantity: 1, unit_price: 500, status: 1)
      InvoiceItem.create!(item_id: @item_9.id, invoice_id: @invoice_9.id, quantity: 1, unit_price: 824, status: 0)
      InvoiceItem.create!(item_id: @item_10.id, invoice_id: @invoice_10.id, quantity: 1, unit_price: 1203, status: 1)
      InvoiceItem.create!(item_id: @item_11.id, invoice_id: @invoice_11.id, quantity: 1, unit_price: 534, status: 1)
      InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_11.id, quantity: 1, unit_price: 467, status: 1)
      InvoiceItem.create!(item_id: @item_9.id, invoice_id: @invoice_8.id, quantity: 1, unit_price: 824, status: 1)

      Transaction.create!(invoice_id: @invoice_1.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_2.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_3.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_4.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_5.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_6.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_7.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_8.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_9.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_10.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_11.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
    end

    it 'lists all discounts on index page' do
      visit "/merchants/#{@merchant_1.id}/discounts"

      within("#discount-#{@discount_1.id}") do
        expect(page).to have_content(@discount_1.pct_discount * 100)
        expect(page).to have_content(@discount_1.threshold)
      end

      within("#discount-#{@discount_2.id}") do
        expect(page).to have_content(@discount_2.pct_discount * 100)
        expect(page).to have_content(@discount_2.threshold)
      end

      within("#discount-#{@discount_3.id}") do
        expect(page).to have_content(@discount_3.pct_discount * 100)
        expect(page).to have_content(@discount_3.threshold)
      end
    end

    it 'lists three upcoming holidays on page' do
      visit "/merchants/#{@merchant_1.id}/discounts"

      next_three_holidays = NagerAPI.upcoming_holidays

      expect(page).to have_content("#{next_three_holidays[0].name}: #{next_three_holidays[0].date}")
      expect(page).to have_content("#{next_three_holidays[1].name}: #{next_three_holidays[1].date}")
      expect(page).to have_content("#{next_three_holidays[2].name}: #{next_three_holidays[2].date}")
    end

    it 'has link to create a new discount' do
      visit "/merchants/#{@merchant_1.id}/discounts"

      expect(page).to have_link("Create A New Discount")
    end

    it 'can add a new bulk discount after clicking on link' do
      visit "/merchants/#{@merchant_1.id}/discounts"

      expect(page).to have_no_content('40.0%')
      expect(page).to have_no_content('50')

      click_link("Create A New Discount")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/new")

      fill_in(:pct_discount, with: 0.40)
      fill_in(:threshold, with: 50)
      click_on("Submit")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts")
      expect(page).to have_content('40.0%')
      expect(page).to have_content('50')
    end

    it 'displays flash notice if bulk discount is already there' do
      visit "/merchants/#{@merchant_1.id}/discounts"

      within("#discount-#{@discount_1.id}") do
        expect(page).to have_content(@discount_1.pct_discount * 100)
        expect(page).to have_content(@discount_1.threshold)
      end

      click_link("Create A New Discount")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/new")

      fill_in(:pct_discount, with: 0.10)
      fill_in(:threshold, with: 10)
      click_on("Submit")

      expect(page).to have_content('You already have this bulk discount. Please fill in again.')
    end
  end
end
