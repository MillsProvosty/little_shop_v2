require 'rails_helper'

RSpec.describe 'as a visitor or a registered user', type: :feature do
  before :each do
    @user_1 = create(:user, role: "user")

    @merchant = create(:merchant)
    @i1, @i2, @i3, @i4, @i5 = create_list(:item, 5, user: @merchant, price: 3)
    @o1 = create(:order)
    @io1 = create(:order_item, item: @i1, order: @o1, quantity: 2)
    @io2 = create(:order_item, item: @i2, order: @o1, quantity: 1)
    @io3 = create(:order_item, item: @i3, order: @o1, price: 2)
    @io4 = create(:order_item, item: @i4, order: @o1, price: 3)
    @io5 = create(:order_item, item: @i5, order: @o1, price: 6)
  end

  describe 'I visit my cart and see a link to empty my cart' do
    it 'shows item name, small image of item, merchant, price, desired quantity and sub total' do

       visit login_path

       fill_in "email",  with: @user_1.email
       fill_in "password", with: @user_1.password
       click_on "Log In"


      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i2)
      click_button "Add Item"

      visit cart_path


        within('.cart') do
          expect(page).to have_content(@i1.name)
          expect(find("#image-#{@i1.id}")[:src]).to eq(@i1.image)
          expect(page).to have_content(@i1.user.name)
          expect(page).to have_content(@i1.price)
          expect(page).to have_content(2)
          expect(page).to have_content(1)
          expect(page).to have_content("Subtotal: #{number_to_currency(@i1.item_subtotal)}")
        end
        expect(page).to have_content("Grand total: #{number_to_currency(@i1.item_subtotal + @i2.item_subtotal)}")
        expect(page).to have_link("Empty My Cart")

    end

    describe "When I add no items and I visit cart " do
      it "I see a message that Cart is Empty and no link to empty the cart" do
        user = create(:user, role: "user")

        visit login_path

        fill_in "email",  with: user.email
        fill_in "password", with: user.password
        click_on "Log In"

        visit cart_path

        expect(page).to have_content("Cart is Empty")
        expect(page).to_not have_link("Empty My Cart")
      end

      it "I see a message that Cart is Empty and no link to empty the cart" do

        visit cart_path

        expect(page).to have_content("Cart is Empty")
        expect(page).to_not have_link("Empty My Cart")
      end
    end
  end

  describe 'I can empty a cart that has items' do
    it 'vistor empties cart' do
      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i2)
      click_button "Add Item"

      visit cart_path

      expect(page).to have_content("Cart: 3")
      click_link "Empty My Cart"

      expect(current_path).to eq(cart_path)
      expect(page).to have_content("Cart: 0")
    end

    it 'registered user empties cart' do

      user = create(:user)

      visit login_path

      fill_in "email", with: user.email
      fill_in "password", with: user.password

      click_on "Log In"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i2)
      click_button "Add Item"

      visit cart_path

      expect(page).to have_content("Cart: 3")
      click_link "Empty My Cart"

      expect(current_path).to eq(cart_path)
      expect(page).to have_content("Cart: 0")
    end

    it 'vistor removes items from cart' do
      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i2)
      click_button "Add Item"

      visit cart_path

      within("#item-#{@i2.id}") do
        click_on "Remove Item"
      end

      expect(current_path).to eq(cart_path)

      expect(page).to_not have_content(@i2.name)
      expect(page).to have_content(@i1.name)

      expect(page).to have_content("Cart: 2")
    end

    it 'registered user removes items from cart' do
      user = create(:user)

      visit login_path

      fill_in "email", with: user.email
      fill_in "password", with: user.password

      click_on "Log In"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i1)
      click_button "Add Item"

      visit item_path(@i2)
      click_button "Add Item"

      visit cart_path

      within "#item-#{@i1.id}" do
        click_on "Remove Item"
      end

      expect(current_path).to eq(cart_path)

      expect(page).to_not have_content(@i1.name)
      expect(page).to have_content(@i2.name)

      expect(page).to have_content("Cart: 1")
    end

    describe 'decrement and increment items in cart' do
      before :each do
        merchant = create(:merchant)
        @i1,@i3,@i4,@i5 = create_list(:item,5, user: merchant)
        @i2 = create(:item, user: merchant, inventory: 3)

        visit item_path(@i1)
        click_button "Add Item"

        visit item_path(@i1)
        click_button "Add Item"

        visit item_path(@i2)
        click_button "Add Item"

        visit item_path(@i2)
        click_button "Add Item"

        visit cart_path

      end

      it 'vistor increments items in cart' do
        within("#add-item-#{@i2.id}") do

          click_button "Add one"
        end

        within("#add-item-#{@i2.id}") do
          click_on "Add one"
        end

        expect(current_path).to eq(cart_path)

        expect(page).to have_content("Cart: 5")

        within("#item-#{@i2.id}") do
          expect(page).to have_content("Desired Quantity: 3")
        end
      end

      it 'vistor decrements items in cart' do
        within("#eliminate-item-#{@i2.id}") do
          click_button "Eliminate one"
        end

        within("#item-#{@i2.id}") do
          expect(page).to have_content("Desired Quantity: 1")
        end

        within("#eliminate-item-#{@i2.id}") do
          click_on "Eliminate one"
        end

        expect(current_path).to eq(cart_path)

        expect(page).to have_content("Cart: 2")
        expect(page).to_not have_content(@i2.name)
      end

      it 'registered user decrements items in cart' do
        user = create(:user)

        visit login_path

        fill_in "email", with: user.email
        fill_in "password", with: user.password

        click_on "Log In"

        visit cart_path

        within("#eliminate-item-#{@i2.id}") do
          click_button "Eliminate one"
        end

        within("#item-#{@i2.id}") do
          expect(page).to have_content("Desired Quantity: 1")
        end

        within("#eliminate-item-#{@i2.id}") do
          click_on "Eliminate one"
        end

        expect(current_path).to eq(cart_path)

        expect(page).to have_content("Cart: 2")
        expect(page).to_not have_content(@i2.name)
      end
    end

    describe "as a visitor with items in my cart" do
      before :each do
        merchant = create(:merchant)
        @i1,@i3,@i4,@i5 = create_list(:item,5, user: merchant)
        @i2 = create(:item, user: merchant, inventory: 3)

        visit item_path(@i1)
        click_button "Add Item"

        visit item_path(@i1)
        click_button "Add Item"

        visit item_path(@i2)
        click_button "Add Item"

        visit item_path(@i2)
        click_button "Add Item"

      end

        it "I see a message telling me i must register or log in to checkout" do
          visit cart_path

          expect(page).to have_content("You must register or log in to checkout.")
          expect(page).to have_link("register")
          expect(page).to have_link("log in")
        end

        it "I see a message telling me I must register or log in to checkout" do
          user = create(:user)
          order = create(:order, user: user)

          visit login_path

          fill_in "email", with: user.email
          fill_in "password", with: user.password

          click_on "Log In"

          visit cart_path

          expect(page).to_not have_content("You must register or log in to checkout.")
          expect(page).to_not have_link("register")
          expect(page).to_not have_link("log in")
          expect(page).to have_link("Checkout")
          click_link "Checkout"

          expect(current_path).to eq(user_orders_path)
          expect(page).to have_content("Your order was created.")
          expect(page).to have_content("Order: #{order.id}")
          expect(page).to have_content(order.status)
          expect(page).to have_content(order.created_at)
          expect(page).to have_content(order.created_at)
          expect(page).to have_content("Cart: 0")
      end
    end

  describe 'As a registered user, when I add items to my cart and I visit my cart' do
    before :each do
      @user = create(:user)
      @order = create(:order, user: @user)
      @item1 = create(:item)
      @item2 = create(:item)
      @item3 = create(:item)

      @oi1 = create(:order_item, order: @order, item: @item1)
      @oi2 = create(:order_item, order: @order, item: @item2)
      @oi3 = create(:order_item, order: @order, item: @item3)

      visit login_path

      fill_in "email", with: @user.email
      fill_in "password", with: @user.password
      click_on "Log In"

      visit cart_path
    end

      describe "I see a button or link indicating I can checkout" do
        describe "I click the button to checkout and an order is created with 'pending' status" do
          it "I visit profile/orders path and see a flash message saying order was created and I see a new order list, cart is empty " do
            visit cart_path

            click_on "Checkout"
            expect(current_path).to eq(user_orders_path)

            expect(page).to have_content("pending")
            expect(page).to have_content("Your order was created.")
            expect(page).to have_content(@order.status)
            expect(page).to have_content(@order.created_at)
            expect(page).to have_content(@order.updated_at)
            expect(page).to have_content("Cart: 0")
          end
        end
      end
    end
  end
end
