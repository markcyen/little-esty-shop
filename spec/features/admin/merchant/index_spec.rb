require 'rails_helper'

RSpec.describe 'Admin Merchant Index Page' do
  describe 'details on page' do
    before :each do
      @customer_1 = Customer.create!(first_name: 'Jerry', last_name: 'Cantrell')

      @invoice_1 = Invoice.create!(status: 0, customer_id: @customer_1.id)
      @invoice_2 = Invoice.create!(status: 0, customer_id: @customer_1.id)
      @invoice_3 = Invoice.create!(status: 0, customer_id: @customer_1.id)
      @invoice_4 = Invoice.create!(status: 0, customer_id: @customer_1.id)
      @invoice_5 = Invoice.create!(status: 0, customer_id: @customer_1.id)

      @merchant_1 = Merchant.create!(name: 'Roald', status: 'enable')
      @merchant_2 = Merchant.create!(name: 'Marshall', status: 'disable')
      @merchant_3 = Merchant.create!(name: 'Big Rick', status: 'enable')
      @merchant_4 = Merchant.create!(name: 'Debby', status: 'disable')
      @merchant_5 = Merchant.create!(name: 'Linda', status: 'enable')
      @merchant_6 = Merchant.create!(name: 'Roswell',status: 'disable')

      @trasaction_1 = Transaction.create!(credit_card_number: '1928333429810', credit_card_expiration_date: '1121', result: 0, invoice_id: @invoice_1.id)
      @trasaction_2 = Transaction.create!(credit_card_number: '1928333429810', credit_card_expiration_date: '1121', result: 0, invoice_id: @invoice_2.id)
      @trasaction_3 = Transaction.create!(credit_card_number: '1928333429810', credit_card_expiration_date: '1121', result: 0, invoice_id: @invoice_3.id)
      @trasaction_4 = Transaction.create!(credit_card_number: '1928333429810', credit_card_expiration_date: '1121', result: 0, invoice_id: @invoice_4.id)
      @trasaction_5 = Transaction.create!(credit_card_number: '1928333429810', credit_card_expiration_date: '1121', result: 0, invoice_id: @invoice_5.id)

      @item_1 = @merchant_1.items.create!(name: 'Funyuns', description: 'Tasty', unit_price: 2000)
      @item_2 = @merchant_2.items.create!(name: 'Doritos', description: 'Delicious', unit_price: 2844)
      @item_3 = @merchant_3.items.create!(name: 'Peanut M&Ms', description: 'Tasty', unit_price: 2384)
      @item_4 = @merchant_4.items.create!(name: 'Kit-Kat', description: 'Tasty', unit_price: 3820)
      @item_5 = @merchant_5.items.create!(name: 'Burritos', description: 'Tasty', unit_price: 1944)

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id , invoice_id: @invoice_1.id, quantity: 7000, unit_price: 2000, status: 0)
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id , invoice_id: @invoice_2.id, quantity: 5200, unit_price: 2844, status: 0)
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id , invoice_id: @invoice_3.id, quantity: 7300, unit_price: 2384, status: 0)
      @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id , invoice_id: @invoice_4.id, quantity: 8400, unit_price: 3820, status: 0)
      @invoice_item_5 = InvoiceItem.create!(item_id: @item_5.id , invoice_id: @invoice_5.id, quantity: 9500, unit_price: 3944, status: 0)

      visit '/admin/merchants'
    end

    it 'shows all merchants' do
      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@merchant_2.name)
      expect(page).to have_content(@merchant_3.name)
      expect(page).to have_content(@merchant_4.name)
      expect(page).to have_content(@merchant_5.name)
      expect(page).to have_content(@merchant_6.name)
    end

    it 'groups by status' do
      within('#disabled_merchants') do
        expect(page).to have_content(@merchant_2.name)
        expect(page).to have_content(@merchant_4.name)
        expect(page).to have_content(@merchant_6.name)
        expect(page).to_not have_content(@merchant_1.name)
      end

      within('#enabled_merchants') do
          expect(page).to have_content(@merchant_1.name)
          expect(page).to have_content(@merchant_3.name)
          expect(page).to have_content(@merchant_5.name)
          expect(page).to_not have_content(@merchant_6.name)
      end
    end

    it 'shows top five merchants by total revenue' do

      within('#top_five') do
        expect(@merchant_5.name).to appear_before(@merchant_4.name)
        expect(@merchant_4.name).to appear_before(@merchant_3.name)
        expect(@merchant_3.name).to appear_before(@merchant_2.name)
        expect(@merchant_2.name).to appear_before(@merchant_1.name)
      end
    end

    it 'has a link to create a new merchant' do
      click_on 'Create New Merchant'

      expect(current_path).to eq("/admin/merchants/new")
    end

    it 'can create a new merchant' do
      expect(page).to_not have_content('Miles')

      click_on 'Create New Merchant'

      fill_in :name, with: 'Miles'

      click_on 'Create Merchant'

      expect(current_path).to eq('/admin/merchants')

      within('#disabled_merchants') do
        expect(page).to have_content('Miles')
      end
    end

    it 'shows a button next to name with enable or disable' do
      within('#enabled_merchants') do
        expect(page).to have_button("Disable #{@merchant_1.name}")
      end

      within('#disabled_merchants') do
        expect(page).to have_button("Enable #{@merchant_2.name}")
      end
    end
    it 'shows each merchant of the top fives best day' do
      within('#top_five') do
        expect(page).to have_content((Time.now + 6.hour).strftime('%m/%d/%Y'))
      end
    end
  end

end
