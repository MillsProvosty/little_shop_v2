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
      expect(page).to have_content("Description: #{@item.description}")
      expect(find("img")[:src]).to eq(@item.image)
      expect(page).to have_content("Merchant: #{@item.user.name}")
      expect(page).to have_content("Availability: #{@item.inventory}")
      expect(page).to have_content("Price: $#{@item.price}")
      expect(page).to have_content("Average Fulfilled Time: #{@item.avg_fulfill_time} hours")
    end

    it "from the item show page theres a link to add to my cart, as visitor or reg user" do


      visit item_path(@item)

      expect(page).to have_button("Add Item to Cart")
    end

    it "When I click Add Item to Cart, I am returned to items index, and there is a flash message for an added item and the nav bar increment number of items in cart" do

      visit item_path(@item)

      click_button "Add Item to Cart"

      expect(current_path).to eq(items_path)
      expect(page).to have_content("You now have 1 #{@item.name} added to cart.")

      within(".nav-cart") do
        expect(page).to have_content("Cart: 1")
      end
    end
  end
end
