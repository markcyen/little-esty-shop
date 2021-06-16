require 'rails_helper'

RSpec.describe 'Merchant Items Index' do
  describe 'Merchant Items Index Page' do
    before :each do
      @merchant_1 = Merchant.create!(name: "Regina's Ragin' Ragdolls")
      @merchant_2 = Merchant.create!(name: "Mark's Money Makin' Markers")
      @merchant_3 = Merchant.create!(name: "Caleb's California Catapults")

      @item_1 = @merchant_1.items.create!(name: "Twinkies", description: "Yummy", unit_price: 400)
      @item_2 = @merchant_1.items.create!(name: "Applesauce", description: "Yummy", unit_price: 400)
      @item_3 = @merchant_1.items.create!(name: "Milk", description: "Yummy", unit_price: 400)
      @item_4 = @merchant_1.items.create!(name: "Bread", description: "Yummy", unit_price: 400)
      @item_5 = @merchant_1.items.create!(name: "Ice Cream", description: "Yummy", unit_price: 400)
      @item_6 = @merchant_1.items.create!(name: "Waffles", description: "Yummy", unit_price: 400)

      @customer_1 = Customer.create!(first_name: "Regina", last_name: "Last Name")
      @customer_2 = Customer.create!(first_name: "Jennifer", last_name: "Last Name")
      @customer_3 = Customer.create!(first_name: "Mark", last_name: "Last Name")
      @customer_4 = Customer.create!(first_name: "Caleb", last_name: "Last Name")
      @customer_5 = Customer.create!(first_name: "Richard", last_name: "Last Name")
      @customer_6 = Customer.create!(first_name: "Zach", last_name: "Last Name")

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 0)
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 1)
      @invoice_3 = Invoice.create!(customer_id: @customer_3.id, status: 1)
      @invoice_4 = Invoice.create!(customer_id: @customer_4.id, status: 1)
      @invoice_5 = Invoice.create!(customer_id: @customer_5.id, status: 1)
      @invoice_6 = Invoice.create!(customer_id: @customer_6.id, status: 1)


      InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 5, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_3.id, quantity: 2, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_4.id, quantity: 3, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_5.id, quantity: 4, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_5.id, quantity: 4, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_6.id, quantity: 2, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: 1500, status: 0)
      InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_6.id, quantity: 2, unit_price: 1500, status: 0)

      Transaction.create!(invoice_id: @invoice_2.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_3.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_4.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_5.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
      Transaction.create!(invoice_id: @invoice_6.id, result: 0, credit_card_number: '12345', credit_card_expiration_date: '12345')
    end

    it 'Can visit a merchant index page' do
      merchant = Merchant.create!(name: 'Schroeder-Jerde')
      merchant.items.create!(name: 'Item Qui Esse', description: 'description', unit_price: 7510)
      visit "/merchants/#{merchant.id}/items"
      expect(current_path).to eq("/merchants/#{merchant.id}/items")
      expect(page).to have_content('Schroeder-Jerde')
      expect(page).to have_content('Item Qui Esse')
    end

    it 'can update status of an item' do
      @merchant = Merchant.create!(name: 'Schroeder-Jerde')
      @item_10 = @merchant.items.create!(name: 'Item Qui Esse', description: 'description', unit_price: 7510, status: "enable")
      visit "/merchants/#{@merchant.id}/items"
      # binding.pry
      find_button("Disable").click


      expect(current_path).to eq("/merchants/#{@merchant.id}/items")
      expect(page).to have_button("Enable")

      @item_10 = Item.find(@item_10.id)

      expect(@item_10.status).to eq("disable")
    end

    it 'Items are separated into enable and disable' do
      @merchant = Merchant.create!(name: 'Schroeder-Jerde')
      @item_10 = @merchant.items.create!(name: 'Item Qui Esse', description: 'description', unit_price: 7510, status: "enable")
      visit "/merchants/#{@merchant.id}/items"

      expect(current_path).to eq("/merchants/#{@merchant.id}/items")
      expect(page).to have_content("Disabled Items")
      expect(page).to have_content("Enabled Items")
    end

    it 'Can add a new item for merchant' do
      @merchant = Merchant.create!(name: 'Schroeder-Jerde')
      @item_10 = @merchant.items.create!(name: 'Item Qui Esse', description: 'description', unit_price: 7510, status: "enable")
      visit "/merchants/#{@merchant.id}/items"

      expect(current_path).to eq("/merchants/#{@merchant.id}/items")

      expect(page).to have_button("Add a New Item")
      click_button("Add a New Item")

      expect(current_path).to eq("/merchants/#{@merchant.id}/items/new")
      fill_in( 'Name', with: "New Item Name")
      fill_in( 'Description', with: "Made from 100% cotton.")
      fill_in( 'Unit price', with: 75608)
      click_on("Submit")

      expect(current_path).to eq("/merchants/#{@merchant.id}/items")
      expect(page).to have_content("New Item Name")
    end

    it 'shows top 5 times for merchant' do
      visit "/merchants/#{@merchant_1.id}/items"
      # save_and_open_page
      expect(page).to have_content("1. Ice Cream $120.0")
      expect(page).to have_content("2. Applesauce $90.0")
      expect(page).to have_content("3. Waffles $60.0")
      expect(page).to have_content("4. Bread $45.0")
      expect(page).to have_content("5. Milk $30.0")
    end

    it 'shows top day for merchant' do
      visit "/merchants/#{@merchant_1.id}/items"
      expect(page).to have_content("Top selling date for Ice Cream was #{(Time.now + 6.hour).strftime('%m/%d/%Y')}")
      expect(page).to have_content("Top selling date for Applesauce was #{(Time.now + 6.hour).strftime('%m/%d/%Y')}")
      expect(page).to have_content("Top selling date for Waffles was #{(Time.now + 6.hour).strftime('%m/%d/%Y')}")
      expect(page).to have_content("Top selling date for Bread was #{(Time.now + 6.hour).strftime('%m/%d/%Y')}")
    end
  end
end
