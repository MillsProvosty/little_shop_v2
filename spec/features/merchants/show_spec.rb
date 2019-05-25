require 'rails_helper'

RSpec.describe 'Merchant Show page' do
  describe 'when I visit my dashboard' do

    before :each do
      @merchant = create(:merchant)
      @i1,@i2,@i3,@i4,@i5,@i6,@i7,@i8,@i9 = create_list(:item, 10, user: @merchant)
      @i10,@i11 = create_list(:item, 2, user: @merchant)

      @o1,@o2,@o3 = create_list(:order, 3)
      @o4,@o5 = create_list(:order, 2, status: 'shipped')

      create(:order_item, item: @i1, order: @o1)
      create(:order_item, item: @i2, order: @o1)
      create(:order_item, item: @i3, order: @o1)
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

    it 'i see my profile data but cannot edit it' do
      expect(current_path).to eq(merchant_dashboard_path)

      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.email)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)

      expect(page).to_not have_link("Edit Profile")
    end


    it 'I see a list of pending orders and their information' do
      within '#order-info' do
        expect(page).to have_link("Order# " << @o1.id.to_s)
        expect(page).to have_link("Order# " << @o2.id.to_s)
        expect(page).to have_link("Order# " << @o3.id.to_s)
        expect(page).to_not have_link("Order# " << @o4.id.to_s)
        expect(page).to_not have_link("Order# " << @o5.id.to_s)

        expect(page).to have_content("Date Ordered: " << @o1.created_at.strftime("%B %d, %Y"))
        expect(page).to have_content("Date Ordered: " << @o2.created_at.strftime("%B %d, %Y"))
        expect(page).to have_content("Date Ordered: " << @o3.created_at.strftime("%B %d, %Y"))

        expect(page).to have_content("Quantity: " << @o1.item_quantity.to_s)
        expect(page).to have_content("Quantity: " << @o2.item_quantity.to_s)
        expect(page).to have_content("Quantity: " << @o3.item_quantity.to_s)

        expect(page).to have_content("Grand Total: $" << @o1.items_total_value.to_f.to_s)
        expect(page).to have_content("Grand Total: $" << @o2.items_total_value.to_f.to_s)
        expect(page).to have_content("Grand Total: $" << @o3.items_total_value.to_f.to_s)
      end
    end
  end
end
