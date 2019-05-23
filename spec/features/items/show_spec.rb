require 'rails_helper'

RSpec.describe "As any user" do
  before :each do
    @merchant = create(:merchant)
    @item = create(:item, user: @merchant)
    @io_1 = create(:order_item, item: @item, created_at: 3.days.ago)
    @io_1.fulfilled = true
    @io_2 = create(:order_item, item: @item, created_at: 5.days.ago)
    @io_2.fulfilled = true
    @io_3 = create(:order_item, item: @item, created_at: 7.days.ago)
    @io_3.fulfilled = true

  end
  describe "When I visit an item's show page from the items catalog" do
    it "I see name, description, image, merchant, quantity, price, time to fulfill" do
      visit item_path(@item)
      expect(page).to have_content(@item.name)
      expect(page).to have_content(@item.description)
      expect(find("img")[:src]).to eq(@item.image)
      expect(page).to have_content(@item.user.name)
      expect(page).to have_content(@item.inventory)
      expect(page).to have_content(@item.price)
      expect(page).to have_content("Average Fulfilled Time: #{@item.avg_fulfill_time} hours")
    end
  end
end
