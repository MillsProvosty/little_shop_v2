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
      item_3 = create(:item, user: merchant, active: true, inventory: 100000)
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
      expect(@item.active).to eq(true)
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
      expect(@item.active).to eq(true)

      within("#item-#{@item.id}") do
        expect(page).to have_content("Iphone")
        expect(page).to have_content(800.00)
        expect(page).to have_content("Good phone")
        expect(find('img')[:src]).to eq("https://picsum.photos/200/300")
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
      it "A price must be greater than zero" do

        visit merchant_items_path

        within(".links") do
          click_link "Add an Item"
        end
        expect(current_path).to eq(new_merchant_item_path)

        fill_in "Name", with: "Iphone"
        fill_in "Price", with: 0
        fill_in "Description", with: "Good phone"
        fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
        fill_in "Inventory", with: 33
        click_on "Create Item"

        expect(page).to have_content("Price amount must be greater than zero")
        expect(find_field("Name").value).to eq("Iphone")
        expect(find_field("Price").value).to eq("0")
        expect(find_field("Description").value).to eq("Good phone")
        expect(find_field("Image").value).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(find_field("Inventory").value).to eq("33")
      end
      it "Inventory value must be greater than zero" do

        visit merchant_items_path

        within(".links") do
          click_link "Add an Item"
        end
        expect(current_path).to eq(new_merchant_item_path)

        fill_in "Name", with: "Iphone"
        fill_in "Price", with: 30.0
        fill_in "Description", with: "Good phone"
        fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
        fill_in "Inventory", with: 0
        click_on "Create Item"

        expect(page).to have_content("Inventory amount must be greater than zero")
        expect(find_field("Name").value).to eq("Iphone")
        expect(find_field("Price").value).to eq("30.0")
        expect(find_field("Description").value).to eq("Good phone")
        expect(find_field("Image").value).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
        expect(find_field("Inventory").value).to eq("0")
      end
    end
  end
  describe "Merchant can edit an item" do
    before :each do
      @merchant = create(:merchant)
        @item_1 = create(:item, user: @merchant)
        @item_2 = create(:item, user: @merchant, active: false)
        @item_3 = create(:item, user: @merchant)
    end
    describe "When I visit my items page, and I click edit on an item" do
      describe "I am taken to a form similar to the new item form" do
        it "my current route will be dashboard/items/:id/edit" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit merchant_items_path

          within("#item-#{@item_1.id}") do
            click_on "Edit Item"
          end
          expect(current_path).to eq(edit_merchant_item_path(@item_1))
        end
        it "The form is repopulated with all item information" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_1)

          expect(find_field("Name").value).to eq(@item_1.name)

          expect(find_field("Price").value.to_f).to eq(@item_1.price.to_f)

          expect(find_field("Description").value).to eq(@item_1.description)
          expect(find_field("Image").value).to eq(@item_1.image)
          expect(find_field("Inventory").value).to eq("#{@item_1.inventory}")
        end
        it "When I submit the form I am taken back to items page and item is listed, with updated flash message" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_1)

          fill_in "Name", with: "New Item"
          fill_in "Price", with: 200
          fill_in "Description", with: "cool item"
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 22
          click_on "Update Item"

          @item_1.reload

          expect(current_path).to eq(merchant_items_path)

          expect(page).to have_content("#{@item_1.name} has been updated")

          within("#item-#{@item_1.id}") do
            expect(page).to have_content("New Item")
            expect(page).to have_content(200)
            expect(page).to have_content("cool item")
            expect(find('img')[:src]).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
            expect(page).to have_content(22)
          end
        end
        it "When I submit the form I am taken back to items page and item is listed, with its active state staying the same" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "New Item"
          fill_in "Price", with: 200
          fill_in "Description", with: "cool item"
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 22
          click_on "Update Item"

          @item_2.reload

          expect(current_path).to eq(merchant_items_path)

          expect(page).to have_content("#{@item_2.name} has been updated")

          within("#item-#{@item_2.id}") do
            expect(page).to have_content("New Item")
            expect(page).to have_content(200)
            expect(page).to have_content("cool item")
            expect(find('img')[:src]).to eq("https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png")
            expect(page).to have_content(22)
            expect(@item_2.active).to eq(false)
          end
        end
        it "I can change any information, price must be greater than 0" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_1)

          fill_in "Price", with: 0

          click_on "Update Item"

          expect(page).to have_content("Price amount must be greater than zero")
        end
        it "When I submit the form with price less than or equal to zero i get a flash and redirect back to form" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "New Item"
          fill_in "Price", with: 0
          fill_in "Description", with: "cool item"
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 22
          click_on "Update Item"

          @item_2.reload


          expect(page).to have_content("Price amount must be greater than zero")
        end
        it "When I submit the form with inventory less than one i get a flash and redirect back to form" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "New Item"
          fill_in "Price", with: 200
          fill_in "Description", with: "cool item"
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 0
          click_on "Update Item"

          @item_2.reload


          expect(page).to have_content("Inventory amount must be greater than zero")
        end
        it "When I submit the form with missing name i get a flash and redirect back to form" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: ""
          fill_in "Price", with: 200
          fill_in "Description", with: "cool item"
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 12
          click_on "Update Item"

          @item_2.reload


          expect(page).to have_content("Could not create item without name")
        end
        it "When I submit the form with missing price i get a flash and redirect back to form" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "Item new"
          fill_in "Price", with: ""
          fill_in "Description", with: "cool item"
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 12
          click_on "Update Item"

          @item_2.reload


          expect(page).to have_content("Could not create item without a price")
        end
        it "When I submit the form with missing description i get a flash and redirect back to form" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "Item new"
          fill_in "Price", with: 200
          fill_in "Description", with: ""
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: 12
          click_on "Update Item"

          @item_2.reload


          expect(page).to have_content("Could not create item without a description")
        end


        it "Inventory value cannot be empty for editing an item" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "Item new"
          fill_in "Price", with: 200
          fill_in "Description", with: ""
          fill_in "Image", with: "https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c05962484.png"
          fill_in "Inventory", with: ""
          click_on "Update Item"

          @item_2.reload

          expect(page).to have_content("Could not create item without an inventory value")
        end

        it "Cannot create item without an image" do

          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

          visit edit_merchant_item_path(@item_2)

          fill_in "Name", with: "Item new"
          fill_in "Price", with: 200
          fill_in "Description", with: "Cool Thing"
          fill_in "Image", with: "             "
          fill_in "Inventory", with: 3
          click_on "Update Item"

          @item_2.reload

          expect(page).to have_content("Cannot Create item Without Image")
        end
      end
    end
  end
end
