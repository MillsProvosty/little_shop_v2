require 'rails_helper'

RSpec.describe "As a merchant, when I visit my items page" do
  before :each do
    @merchant = create(:merchant)
    @order_1 = create(:order)
      @item_1 = create(:item, user: @merchant, active: true)
      @item_2 = create(:item, user: @merchant, active: false)
      @item_3 = create(:item, user: @merchant, active: true)
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
      expect(page).to have_button("Edit Item")
    end
      within("#item-#{@item_2.id}") do
      expect(page).to have_content(@item_2.id)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_2.image)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content(@item_2.inventory)
      expect(page).to have_button("Edit Item")
    end
      within("#item-#{@item_3.id}") do
      expect(page).to have_content(@item_3.id)
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@item_3.image)
      expect(page).to have_content(@item_3.price)
      expect(page).to have_content(@item_3.inventory)
      expect(page).to have_button("Edit Item")
    end
  end
  it "If no user has ever ordered the item, there is a link to delete the item" do

    visit merchant_items_path

    within("#item-#{@item_1.id}") do
      expect(page).to_not have_button("Delete Item")
    end
    within("#item-#{@item_2.id}") do
      expect(page).to_not have_button("Delete Item")
    end
    within("#item-#{@item_3.id}") do
      expect(page).to have_button("Delete Item")
    end
  end
  it "If an item is enabled, There is a button to disable the item, if disabled, button to enable" do

    visit merchant_items_path

    within("#item-#{@item_1.id}") do
      expect(page).to have_button("Disable Item")
    end
    within("#item-#{@item_2.id}") do
      expect(page).to have_button("Enable Item")
    end
    within("#item-#{@item_3.id}") do
      expect(page).to have_button("Disable Item")
    end
  end
end
