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
  end
    it "I see a link to add a new item to the system" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit merchant_items_path

      within(".links") do
      expect(page).to have_link("Add an Item")
    end

      within("#item-#{@item_1.id}") do
      expect(page).to have_content(@item_1.id)
      expect(page).to have_content(@item_1.name)
      expect(find('img')[:src]).to eq(@item_1.image)
      expect(page).to have_content(@item_1.price)
      expect(page).to have_content(@item_1.inventory)
      expect(page).to have_button("Edit Item")
    end
      within("#item-#{@item_2.id}") do
      expect(page).to have_content(@item_2.id)
      expect(page).to have_content(@item_2.name)
      expect(find('img')[:src]).to eq(@item_2.image)
      expect(page).to have_content(@item_2.price)
      expect(page).to have_content(@item_2.inventory)
      expect(page).to have_button("Edit Item")
    end
      within("#item-#{@item_3.id}") do
      expect(page).to have_content(@item_3.id)
      expect(page).to have_content(@item_3.name)
      expect(find('img')[:src]).to eq(@item_3.image)
      expect(page).to have_content(@item_3.price)
      expect(page).to have_content(@item_3.inventory)
      expect(page).to have_button("Edit Item")
    end
  end
  it "If no user has ever ordered the item, there is a link to delete the item" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

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

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

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
  it "When I click disable item, I see a flash saying item is not for sale, and Item is disabled" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit merchant_items_path

    within("#item-#{@item_1.id}") do
      click_button("Disable Item")
    end

    @item_1.reload

    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("#{@item_1.name} is no longer for sale.")
    expect(@item_1.active).to eq(false)
  end
  it "When I click enable item, the item is updated on the page and there is a flash saying the item is for sale" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit merchant_items_path

    within("#item-#{@item_2.id}") do
      click_button("Enable Item")
    end

    @item_2.reload

    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("#{@item_2.name} is now for sale.")
    expect(@item_2.active).to eq(true)
  end
  describe "Deleting an item" do
  it "Click delete item, redirect to index, flash message that item is deleted, item is not on page" do

    merchant = create(:merchant)
    order_1 = create(:order)
      item_1 = create(:item, user: merchant, active: true)
      item_2 = create(:item, user: merchant, active: false)
      item_3 = create(:item, user: merchant, active: true)
        oi_1 = create(:order_item, order: order_1, item: item_1)
        oi_2 = create(:order_item, order: order_1, item: item_2)
        oi_3 = create(:order_item, order: order_1, item: item_2)

    visit login_path

    fill_in "email", with: merchant.email
    fill_in "password", with: merchant.password
    click_on "Log In"

    visit merchant_items_path

    within("#item-#{item_3.id}") do
      click_button("Delete Item")
    end

    merchant.reload

    expect(current_path).to eq(merchant_items_path)
    expect(page).to have_content("#{item_3.name} has been deleted.")
    expect(page).to_not have_content(item_3.id)
    expect(page).to_not have_content(item_3.price)
    expect(page).to_not have_content(item_3.inventory)
    end
  end
end

# As a merchant
# When I visit my items page
# And I click on a "delete" button or link for an item
# I am returned to my items page
# I see a flash message indicating this item is now deleted
# I no longer see this item on the page
