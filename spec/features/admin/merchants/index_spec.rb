require 'rails_helper'

RSpec.describe "As an admin visiting merchants index" do
  before :each do
    @admin = create(:admin)
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

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end
  
  describe "and I click 'disable' button for enabled merchat, and return to admin's merchant index page" do
    it "returned to admin's merchant index page " do
      visit admin_merchants_path

      click_button "Disable Merchant"

      expect(current_path).to eq(admin_merchants_path)
    end

    xit "I see a flash message that merchant is disabled" do
      expect(current_pate).to have_content("Merchant #{@merchant.name} is now disabled")
    end

    xit "This merchant cannot log in" do
    end
  end
end
