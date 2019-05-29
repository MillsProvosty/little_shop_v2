require 'rails_helper'

RSpec.describe 'Merchant Show page' do
  context 'when I visit my dashboard' do

    before :each do
      @merchant = create(:merchant)
      @i1,@i2,@i3,@i4,@i5,@i6,@i7,@i8,@i9 = create_list(:item, 10, user: @merchant)
      @i10,@i11 = create_list(:item, 2, user: @merchant)

      @o1,@o2,@o3 = create_list(:order, 3)
      @o4,@o5 = create_list(:order, 2, status: 'shipped')

      create(:order_item, item: @i1, order: @o1, price: 3.00, quantity: 5)
      @oi1 = create(:order_item, item: @i2, order: @o1, price: 2.50, quantity: 6)
      create(:order_item, item: @i3, order: @o1, price: 5.25, quantity: 4)
      create(:order_item, item: @i4, order: @o2)
      create(:order_item, item: @i5, order: @o2)
      create(:order_item, item: @i6, order: @o2)
      create(:order_item, item: @i7, order: @o3)
      create(:order_item, item: @i8, order: @o3)
      create(:order_item, item: @i9, order: @o3)
      create(:order_item, item: @i2, order: @o4)
      create(:order_item, item: @i2, order: @o5)
      create_list(:order_item, 15)

      visit login_path


      fill_in "email", with: @merchant.email
      fill_in "password", with: @merchant.password

      click_on "Log In"

    end

    scenario 'i see my profile data but cannot edit it' do
      expect(current_path).to eq(merchant_dashboard_path)

      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.email)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)

      expect(page).to_not have_link("Edit Profile")
    end


    scenario 'I see a list of pending orders and their information' do
      within('#order-info') do
        expect(page).to have_link("Order# #{@o1.id.to_s}")
        expect(page).to have_link("Order# #{@o2.id.to_s}")
        expect(page).to have_link("Order# #{@o3.id.to_s}")
        expect(page).to_not have_link("Order# #{@o4.id.to_s}")
        expect(page).to_not have_link("Order# #{@o5.id.to_s}")

        expect(page).to have_content("Date Ordered: #{@o1.created_at.strftime("%B %d, %Y")}")
        expect(page).to have_content("Date Ordered: #{@o2.created_at.strftime("%B %d, %Y")}")
        expect(page).to have_content("Date Ordered: #{@o3.created_at.strftime("%B %d, %Y")}")

        expect(page).to have_content("Quantity: #{@o1.item_quantity.to_s}")
        expect(page).to have_content("Quantity: #{@o2.item_quantity.to_s}")
        expect(page).to have_content("Quantity: #{@o3.item_quantity.to_s}")

        expect(page).to have_content("Grand Total: #{number_to_currency @o1.items_total_value}")
        expect(page).to have_content("Grand Total: #{number_to_currency @o2.items_total_value}")
        expect(page).to have_content("Grand Total: #{number_to_currency @o3.items_total_value}")
      end
    end

    xscenario 'I can view details of an order as it pertains to me' do
     click_link "Order# #{@o1.id}"
     expect(current_path).to eq(merchant_order_path(@o1))
     customer = @o1.user

     expect(page).to have_content(customer.name)
     expect(page).to have_content(customer.address)
     expect(page).to have_content(customer.city)
     expect(page).to have_content(customer.state)
     expect(page).to have_content(customer.zip)

     #items from my inventory
       within "#item-#{@i1.id}" do
         expect(page).to have_content(@i1.name)
         expect(find("img")[:src]).to eq(@i1.image)
         expect(page).to have_content("Quantity on Order: 5")
         expect(page).to have_content("Price: $3.00")
       end

       within "#item-#{@i2.id}" do
         expect(page).to have_content(@i2.name)
         expect(find("img")[:src]).to eq(@i2.image)
         expect(page).to have_content("Quantity on Order: 6")
         expect(page).to have_content("Price: $4.50")
       end

       within "#item-#{@i3.id}" do
         expect(page).to have_content(@i3.name)
         expect(find("img")[:src]).to eq(@i3.image)
         expect(page).to have_content("Quantity on Order: 4")
         expect(page).to have_content("Price: $6.00")
       end
   end

    scenario 'there is a link to view just my items' do
      expect(page).to have_link('View my items')
      click_link('View my items')

      expect(current_path).to eq(merchant_items_path)
    end

    describe 'when I visit an orders show page from my dashboard' do
      scenario 'I can fulfill part of an order' do
        visit merchant_order_path(@o1)

        within("#item-#{@i2.id}") do

        click_on "Fulfill Item"

        expect(current_path).to eq(merchant_order_path(@o1))
        expect(page).to have_content("Item has been fulfilled")

        end
        expect(page).to have_content("Item fulfilled")
      end
    end
  end
end
