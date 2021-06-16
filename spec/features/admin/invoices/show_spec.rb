require 'rails_helper'

RSpec.describe 'Admin Invoice Show' do
  describe 'admin invoice show page' do
    before(:each) do
      @customer_1  = Customer.create!(first_name: 'Tanya', last_name: 'Tiger')
      @invoice_1 = @customer_1.invoices.create!(status: 0)
      @invoice_2 = @customer_1.invoices.create!(status: 1)
      @invoice_3 = @customer_1.invoices.create!(status: 1)
      @invoice_4 = @customer_1.invoices.create!(status: 2)
      @invoice_5 = @customer_1.invoices.create!(status: 0)

      @merchant_1 = Merchant.create!(name: 'Roald')
      @item_1 = @merchant_1.items.create!(name: 'Doritos', description: 'Delicious', unit_price: 39434)
      @item_2 = @merchant_1.items.create!(name: 'Lays', description: 'Deliciousio', unit_price: 8356)
      @item_3 = @merchant_1.items.create!(name: 'Cadlee', description: 'Perfecto', unit_price: 9064)

      InvoiceItem.create!(invoice: @invoice_1, item: @item_1, status: 1, quantity: 200, unit_price: 39434)
      InvoiceItem.create!(invoice: @invoice_1, item: @item_2, status: 1, quantity: 295, unit_price: 8356)
      InvoiceItem.create!(invoice: @invoice_1, item: @item_3, status: 2, quantity: 382, unit_price: 9064)
      InvoiceItem.create!(invoice: @invoice_4, item: @item_1, status: 2, quantity: 130, unit_price: 39434)
      InvoiceItem.create!(invoice: @invoice_5, item: @item_1, status: 1, quantity: 97, unit_price: 39434)
    end

    it 'displays invoice id and attributes including customer name' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime('%A, %B %d, %Y'))
      expect(page).to have_content(@customer_1.first_name)
      expect(page).to have_content(@customer_1.last_name)
    end

    it 'displays invoice items info' do
      visit "/admin/invoices/#{@invoice_1.id}"

      @check_first_invoice_item = InvoiceItem.find_invoice_items(@invoice_1).first
      within("#id-#{@check_first_invoice_item.id}") do
        expect(page).to have_content(@check_first_invoice_item.name)
        expect(page).to have_content(@check_first_invoice_item.quantity)
        expect(page).to have_content(@check_first_invoice_item.convert_to_dollar)
        expect(page).to have_content(@check_first_invoice_item.status)
      end

      @check_second_invoice_item = InvoiceItem.find_invoice_items(@invoice_1)[0]

      within("#id-#{@check_second_invoice_item.id}") do
        expect(page).to have_content(@check_second_invoice_item.name)
        expect(page).to have_content(@check_second_invoice_item.quantity)
        expect(page).to have_content(@check_second_invoice_item.convert_to_dollar)
        expect(page).to have_content(@check_second_invoice_item.status)
      end
    end

    it 'displays total revenue of a specific invoice' do
      visit "/admin/invoices/#{@invoice_1.id}"
      expected = (Invoice.expected_invoice_revenue(@invoice_1)[0].invoice_revenue.to_f / 100).to_s

      expect(page).to have_content(expected.gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1,"))
    end

    it 'displays a select field or button' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_button('Update Invoice Status')
      expect(@invoice_1.status).to eq('in progress')
    end

    it 'updates status after selection' do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content('in progress')
      page.select('completed', from: :status)
      click_button('Update Invoice Status')
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content('completed')
      @invoice_1.reload
      expect(@invoice_1.status).to eq('completed')
    end
  end

  describe 'Discounted Revenue' do
    before :each do
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
      @invoice_5 = Invoice.create!(customer_id: @customer_1.id, status: 0)

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
      @invoice_item_9 = InvoiceItem.create!(item: @item_1, invoice: @invoice_5, quantity: 25, unit_price: 400, status: 1)
      @invoice_item_10 = InvoiceItem.create!(item: @item_2, invoice: @invoice_5, quantity: 50, unit_price: 340, status: 1)
      @invoice_item_11 = InvoiceItem.create!(item: @item_3, invoice: @invoice_5, quantity: 25, unit_price: 400, status: 1)
      @invoice_item_12 = InvoiceItem.create!(item: @item_4, invoice: @invoice_5, quantity: 50, unit_price: 340, status: 1)

      Transaction.create!(invoice_id: @invoice_1.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_2.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_3.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_4.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_5.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
    end

    it 'displays discounted revenue' do
      visit "/admin/invoices/#{@invoice_5.id}"

      expect(page).to have_content("Expected Invoice Revenue: $540.00")
      expect(page).to have_content("Discounted Invoice Revenue: $496.00")
    end
  end
end
