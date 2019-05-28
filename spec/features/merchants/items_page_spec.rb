require 'rails_helper'

RSpec.describe "As a merchant, when I visit my items page" do
  before :each do
    @merchant = create(:merchant)
    @order_1 = create(:order)
      @item_1 = create(:item, user: @merchant)
      @item_2 = create(:item, user: @merchant)
      @item_3 = create(:item, user: @merchant)
        @oi_1 = create(:order_item, order: @order_1, item: @item_1)
        @oi_2 = create(:order_item, order: @order_1, item: @item_2)
        @oi_3 = create(:order_item, order: @order_1, item: @item_2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

  end
    it "I see a link to add a new item to the system" do

      visit merchant_items_path

      within(".links") do
      expect(page).to have_link("Add an Item")
      end
      within("#item-#{@item_1.id}") do
      expect(page).to have_content(@item_1.id)
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.image)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_1.inventory)
      expect(page).to have_button("Edit Item #{@item_1.name}")
    end
      within("#item-#{@item_2.id}") do
      expect(page).to have_content(@item_2.id)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_2.image)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content(@item_2.inventory)
      expect(page).to have_button("Edit Item #{@item_2.name}")
    end
      within("#item-#{@item_3.id}") do
      expect(page).to have_content(@item_3.id)
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@item_3.image)
      expect(page).to have_content(@item_3.price)
      expect(page).to have_content(@item_3.inventory)
      expect(page).to have_button("Edit Item #{@item_3.name}")
    end
  end
  it "If no user has ever ordered the item, there is a link to delete the item" do

    visit merchant_items_path

    within("#item-#{@item_3.id}") do
      expect(page).to have_button("Delete item")
    end
  end
end





# If no user has ever ordered this item, I see a link to delete the item
# If the item is enabled, I see a button or link to disable the item
# If the item is disabled, I see a button or link to enable the item
