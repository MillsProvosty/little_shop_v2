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
  describe "Adding an item to merchants item index" do
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
    it "Click link to add a new item" do

      visit merchant_items_path

      within(".links") do
        click_link "Add an Item"
      end
      expect(current_path).to eq(new_merchant_item_path)

      fill_in "Name", with: "Laptop"
      fill_in "Price", with: 2000.00
      fill_in "Description", with: "Good quality laptop"
      fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
      fill_in "Inventory", with: 12
      click_on "Create Item"

      expect(current_path).to eq(merchant_items_path)

      @item = Item.last
      expect(page).to have_content("Laptop has been saved.")

      within("#item-#{@item.id}") do
        expect(page).to have_content("Laptop")
        expect(page).to have_content(2000.00)
        expect(page).to have_content("Good quality laptop")
        expect(find('img')[:src]).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(page).to have_content(12)
      end
    end
    it "Uses a default image if the field is left blank on the new item form" do

      visit merchant_items_path

      within(".links") do
        click_link "Add an Item"
      end
      expect(current_path).to eq(new_merchant_item_path)

      fill_in "Name", with: "Iphone"
      fill_in "Price", with: 800.00
      fill_in "Description", with: "Good phone"

      fill_in "Inventory", with: 22
      click_on "Create Item"

      expect(current_path).to eq(merchant_items_path)

      @item = Item.last
      expect(page).to have_content("Iphone has been saved.")

      within("#item-#{@item.id}") do
        expect(page).to have_content("Iphone")
        expect(page).to have_content(800.00)
        expect(page).to have_content("Good phone")
        expect(find('img')[:src]).to eq("http://www.himalayansolution.com/public/img/medium-default-product.jpg")
        expect(page).to have_content(22)
      end
    end
    describe "When I try to add a new item, if any data is incorrect or missing(except image)" do
      describe "I am returned to the form, with a flash message indicating each error"
        it "When I dont fill in an item name, i am redirected to form with a flash saying name is missing, fields are repopulated" do

        visit merchant_items_path

        within(".links") do
          click_link "Add an Item"
        end
        expect(current_path).to eq(new_merchant_item_path)

        # no name filled in
        fill_in "Price", with: 800.00
        fill_in "Description", with: "Good phone"
        fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
        fill_in "Inventory", with: 22
        click_on "Create Item"


        expect(page).to have_content("Could not create item without name")
        expect(find_field("Name").value).to eq("")
        expect(find_field("Price").value).to eq("800.0")
        expect(find_field("Description").value).to eq("Good phone")
        expect(find_field("Image").value).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(find_field("Inventory").value).to eq("22")
      end
        it "When I dont fill in an item price, i am redirected to form with a flash saying name is missing, fields are repopulated" do

        visit merchant_items_path

        within(".links") do
          click_link "Add an Item"
        end
        expect(current_path).to eq(new_merchant_item_path)

        fill_in "Name", with: "Iphone"
        #no price filled in
        fill_in "Description", with: "Good phone"
        fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
        fill_in "Inventory", with: 22
        click_on "Create Item"


        expect(page).to have_content("Could not create item without a price")
        expect(find_field("Name").value).to eq("Iphone")
        expect(find_field("Price").value).to eq("")
        expect(find_field("Description").value).to eq("Good phone")
        expect(find_field("Image").value).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(find_field("Inventory").value).to eq("22")
      end
        it "When I dont fill in an item description, i am redirected to form with a flash saying name is missing, fields are repopulated" do

        visit merchant_items_path

        within(".links") do
          click_link "Add an Item"
        end
        expect(current_path).to eq(new_merchant_item_path)

        fill_in "Name", with: "Iphone"
        fill_in "Price", with: "800.0"
        #no description filled in
        fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
        fill_in "Inventory", with: 22
        click_on "Create Item"


        expect(page).to have_content("Could not create item without a description")
        expect(find_field("Name").value).to eq("Iphone")
        expect(find_field("Price").value).to eq("800.0")
        expect(find_field("Description").value).to eq("")
        expect(find_field("Image").value).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(find_field("Inventory").value).to eq("22")
      end
        it "When I dont fill in an item inventory value, i am redirected to form with a flash saying name is missing, fields are repopulated" do

        visit merchant_items_path

        within(".links") do
          click_link "Add an Item"
        end
        expect(current_path).to eq(new_merchant_item_path)

        fill_in "Name", with: "Iphone"
        fill_in "Price", with: "800.0"
        fill_in "Description", with: "Good phone"
        fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
        #no inventory filled in
        click_on "Create Item"


        expect(page).to have_content("Could not create item without an inventory value")
        expect(find_field("Name").value).to eq("Iphone")
        expect(find_field("Price").value).to eq("800.0")
        expect(find_field("Description").value).to eq("Good phone")
        expect(find_field("Image").value).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(find_field("Inventory").value).to eq("")
      end
    end
  end
end
