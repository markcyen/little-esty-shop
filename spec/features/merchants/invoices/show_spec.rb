require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  describe 'displays details of merchant invoice show page (group project)' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Roald')
      @merchant_2 = Merchant.create!(name: 'Big Rick')

      @customer_1 = Customer.create!(first_name: 'Not', last_name: 'Roald')
      @customer_2 = Customer.create!(first_name: 'Big', last_name: 'Rick')
      @invoice_1 = @customer_1.invoices.create!(status: 1)
      @invoice_2 = @customer_2.invoices.create!(status: 1)
      @item_1 = @merchant_1.items.create!(name: 'Cactus Juice', description: 'Its the quechiest', unit_price: 100)
      @item_2 = @merchant_1.items.create!(name: 'Other Item', description: 'Not so quenchy', unit_price: 234)
      @item_3 = @merchant_1.items.create!(name: 'Not Listed', description: 'Undefined', unit_price: 0)
      @item_4 = @merchant_2.items.create!(name: 'Not Listed', description: 'Undefined', unit_price: 0)
      @invoice_items_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: 1000, status: 0)
      @invoice_items_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: 2340, status: 1)
      @invoice_items_2 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_2.id, quantity: 10, unit_price: 2340, status: 1)

      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    end

    it 'shows the invoice show page' do
      expect(page).to have_content(@invoice_1.id)
    end

    it 'shows invoice status' do
      expect(page).to have_content(@invoice_1.status)
    end

    it 'shows the created at in date format' do
      expect(page).to have_content((Time.now + 6.hour).strftime('%A, %B %d, %Y'))
    end

    it 'shows the customer first and last name' do
      expect(page).to have_content('Not')
      expect(page).to have_content('Roald')
    end

    it 'shows all item names' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to_not have_content(@item_3.name)
    end

    it 'shows quantity ordered' do
      expect(page).to have_content(@invoice_items_1.quantity)
      expect(page).to have_content(@invoice_items_2.quantity)
    end

    it 'shows the unit price' do
      expect(page).to have_content(@invoice_items_1.unit_price.to_f / 100)
      expect(page).to have_content(@invoice_items_2.unit_price.to_f / 100)
    end

    it 'shows the status' do
      visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_2.id}"

      expect(page).to have_content('pending')

      page.select('shipped', from: :status)
      click_button('Update Status')

      expect(current_path).to eq("/merchants/#{@merchant_2.id}/invoices/#{@invoice_2.id}")
      expect(page).to have_content('shipped')
    end

    it 'shows total revenue' do
      expect(page).to have_content("$334.00")
    end
  end

  describe 'displays additional details of merchant invoice show page (solo project)' do
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

    describe '1. one bulk discount but quantity does not meet threshold' do
      it 'applies no bulk discount since quantity does not meet threshold' do
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"

        expect(page).to have_content('Total Revenue with Bulk Discount: $160.60')
        expect(page).to have_content('Note: If total revenue and total revenue with bulk discount are the same, then there were no bulk discount applied.')
      end
    end

    describe '2. one bulk discount and only applies to one item' do
      it 'applies one bulk discount to one item only' do
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_2.id}"

        expect(page).to have_content('Total Revenue with Bulk Discount: $158.20')
      end
    end

    describe '3. two bulk discounts and two separate items' do
      it 'applies two bulk discounts on two items separately' do
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_3.id}"

        expect(page).to have_content('Total Revenue with Bulk Discount: $226.00')
      end
    end

    describe '4. two bulk discounts and two items applied with the largest discount' do
      it 'applies the largest bulk discount to two items since they both meet the highest quantity threshold' do
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_4.id}"

        expect(page).to have_content('Total Revenue with Bulk Discount: $299.20')
      end
    end

    describe '5. one merchant with discounts and the other with none' do
      it 'only applies the discounts to one merchant and not the other since the other does not have any discounts' do
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_5.id}"

        expect(page).to have_content('Total Revenue with Bulk Discount: $226.00')

        visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_5.id}"

        expect(page).to have_content('Total Revenue with Bulk Discount: $270.00')
      end
    end

    describe 'link to discount show page' do
      it 'diplays a link to discount show page' do
        visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_2.id}"

        within("#invoice_item-#{@invoice_item_3.item_id}") do
          expect(page).to have_link("Discount Page")
        end

        within("#invoice_item-#{@invoice_item_4.item_id}") do
          expect(page).to_not have_link("Discount Page")
        end

        within("#invoice_item-#{@invoice_item_3.item_id}") do
          click_link("Discount Page")
        end

        expect(current_path).to eq("/merchants/#{@merchant_1.id}/discounts/#{@discount_1.id}")

        visit "/merchants/#{@merchant_2.id}/invoices/#{@invoice_5.id}"

        within("#invoice_item-#{@invoice_item_11.item_id}") do
          expect(page).to_not have_link("Discount Page")
        end
        within("#invoice_item-#{@invoice_item_12.item_id}") do
          expect(page).to_not have_link("Discount Page")
        end
      end
    end
  end
end
