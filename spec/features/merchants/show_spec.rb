require 'rails_helper'

RSpec.describe 'Merchant Show page' do
  context 'when I visit my dashboard' do

    before :each do
      @merchant = create(:merchant)
      @i1,@i2,@i3,@i4,@i5,@i6,@i7,@i8,@i9 = create_list(:item, 10, user: @merchant, price: 1.00)

      #item with different merchant
      @i12,@i13 = create_list(:item, 2)

      #orders with pending status
      @o1,@o2,@o3 = create_list(:order, 3)

      #orders with shipped status
      @o4,@o5,@o6 = create_list(:order, 3, status: 'shipped')

      create(:order_item, item: @i1, order: @o1, quantity: 1)
      create(:order_item, item: @i2, order: @o1, quantity: 2)
      create(:order_item, item: @i3, order: @o1, quantity: 3)
      create(:order_item, item: @i4, order: @o2, quantity: 6)
      create(:order_item, item: @i5, order: @o2, quantity: 2)
      create(:order_item, item: @i6, order: @o2, quantity: 4)
      create(:order_item, item: @i7, order: @o3, quantity: 9)
      create(:order_item, item: @i8, order: @o3, quantity: 5)
      create(:order_item, item: @i9, order: @o3, quantity: 6)
      create(:order_item, item: @i2, order: @o4, quantity: 1)
      create(:order_item, item: @i2, order: @o5, quantity: 2)

      #shipped order
      create(:order_item, item: @i2, order: @o6, quantity: 2, fulfilled: true)
      create(:order_item, item: @i7, order: @o6, quantity: 20, fulfilled: true)
      create(:order_item, item: @i4, order: @o6, quantity: 19, fulfilled: true)
      create(:order_item, item: @i9, order: @o6, quantity: 17, fulfilled: true)
      create(:order_item, item: @i8, order: @o6, quantity: 15, fulfilled: true)
      create(:order_item, item: @i6, order: @o6, quantity: 13, fulfilled: true)

      #additional items added to order from different merchant
      create(:order_item, item: @i13, order: @o1, fulfilled: true)
      create(:order_item, item: @i12, order: @o1, fulfilled: true)

      visit login_path

      fill_in "email", with: @merchant.email
      fill_in "password", with: @merchant.password

      click_on "Log In"
    end

    scenario 'i see my profile data but cannot edit it' do
      expect(current_path).to eq(merchant_dashboard_path)

      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.email)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)

      expect(page).to_not have_link("Edit Profile")
    end


    scenario 'I see a list of pending orders and their information' do
      within('#order-info') do
        expect(page).to have_link("Order# #{@o1.id.to_s}")
        expect(page).to have_link("Order# #{@o2.id.to_s}")
        expect(page).to have_link("Order# #{@o3.id.to_s}")
        expect(page).to_not have_link("Order# #{@o4.id.to_s}")
        expect(page).to_not have_link("Order# #{@o5.id.to_s}")

        expect(page).to have_content("Date Ordered: #{@o1.created_at.strftime("%B %d, %Y")}")
        expect(page).to have_content("Date Ordered: #{@o2.created_at.strftime("%B %d, %Y")}")
        expect(page).to have_content("Date Ordered: #{@o3.created_at.strftime("%B %d, %Y")}")

        expect(page).to have_content("Quantity: #{@o1.item_count_for_merchant(@merchant)}")
        expect(page).to have_content("Quantity: #{@o2.item_count_for_merchant(@merchant)}")
        expect(page).to have_content("Quantity: #{@o3.item_count_for_merchant(@merchant)}")

        expect(page).to have_content("Grand Total: #{number_to_currency @o1.item_total_value_for_merchant(@merchant.id)}")
        expect(page).to have_content("Grand Total: #{number_to_currency @o2.item_total_value_for_merchant(@merchant.id)}")
        expect(page).to have_content("Grand Total: #{number_to_currency @o3.item_total_value_for_merchant(@merchant.id)}")
      end
    end

    xscenario 'I can view details of an order as it pertains to me' do
     click_link "Order# #{@o1.id}"
     expect(current_path).to eq(merchant_order_path(@o1))
     customer = @o1.user

     expect(page).to have_content(customer.name)
     expect(page).to have_content(customer.address)
     expect(page).to have_content(customer.city)
     expect(page).to have_content(customer.state)
     expect(page).to have_content(customer.zip)

     #items from my inventory
       within "#item-#{@i1.id}" do
         expect(page).to have_content(@i1.name)
         expect(find("img")[:src]).to eq(@i1.image)
         expect(page).to have_content("Quantity on Order: 5")
         expect(page).to have_content("Price: $3.00")
       end

       within "#item-#{@i2.id}" do
         expect(page).to have_content(@i2.name)
         expect(find("img")[:src]).to eq(@i2.image)
         expect(page).to have_content("Quantity on Order: 6")
         expect(page).to have_content("Price: $4.50")
       end

       within "#item-#{@i3.id}" do
         expect(page).to have_content(@i3.name)
         expect(find("img")[:src]).to eq(@i3.image)
         expect(page).to have_content("Quantity on Order: 4")
         expect(page).to have_content("Price: $6.00")
       end
   end

    scenario 'there is a link to view just my items' do
      expect(page).to have_link('View my items')
      click_link('View my items')

      expect(current_path).to eq(merchant_items_path)
    end
    scenario 'I can view details of an order as it pertains to me' do
      click_link "Order# #{@o1.id}"
      expect(current_path).to eq(merchant_order_path(@o1))
      customer = @o1.user

      expect(page).to have_content(customer.name)
      expect(page).to have_content(customer.address)
      expect(page).to have_content(customer.city)
      expect(page).to have_content(customer.state)
      expect(page).to have_content(customer.zip)

      #items from my inventory
      within "#item-#{@i1.id}" do
        expect(page).to have_content(@i1.name)
        expect(find("img")[:src]).to eq(@i1.image)
        expect(page).to have_content("Quantity on Order: 1")
        expect(page).to have_content("Price: $1.00")
      end

      within "#item-#{@i2.id}" do
        expect(page).to have_content(@i2.name)
        expect(find("img")[:src]).to eq(@i2.image)
        expect(page).to have_content("Quantity on Order: 2")
        expect(page).to have_content("Price: $1.00")
      end

      within "#item-#{@i3.id}" do
        expect(page).to have_content(@i3.name)
        expect(find("img")[:src]).to eq(@i3.image)
        expect(page).to have_content("Quantity on Order: 3")
        expect(page).to have_content("Price: $1.00")
      end
    end


    describe "I see an area with statistics" do

      it " top 5 items sold by quantity, quantity of each" do
        within("#merchant_stats") do
          #7,4,9,8,6
          expect(page).to have_content("Top 5 items sold:")
          expect(page.all("p")[0]).to have_content("#{@i7.name} : #{@i7.quantity_bought}")
          expect(page.all("p")[1]).to have_content("#{@i4.name} : #{@i4.quantity_bought}")
          expect(page.all("p")[2]).to have_content("#{@i9.name} : #{@i9.quantity_bought}")
          expect(page.all("p")[3]).to have_content("#{@i8.name} : #{@i8.quantity_bought}")
          expect(page.all("p")[4]).to have_content("#{@i6.name} : #{@i6.quantity_bought}")
        end

      end

      it "shows total quantity of items sold, % against sold units plus remaining inventory" do
        visit merchant_dashboard_path

        expect(page).to have_content("Quantity Sold vs. Remaining Inventory")
        expect(page).to have_content("Item: #{@i1.name}#{@i1.quantity_bought}, Percentage Remaining: #{number_to_percentage(@i1.percentage_remaining)}")
        expect(page).to have_content("Item: #{@i3.name}#{@i3.quantity_bought}, Percentage Remaining: #{number_to_percentage(@i3.percentage_remaining)}")
        expect(page).to have_content("Item: #{@i7.name}#{@i7.quantity_bought}, Percentage Remaining: #{number_to_percentage(@i7.percentage_remaining)}")
      end

      it "shows top 3 states where items were shipped/quantities shipped, and the top 3 city/states where items shipped and quantities " do
        visit merchant_dashboard_path

        expect(page).to have_content("Top Three States Where Items Were Shipped:")
        expect(page.all("p")[0]).to have_content("#{@i7.name} : #{@i7.quantity_bought}")

        within("#states") do
          state_1,state_2,state_3 = @merchant.top_three_states
          expect(page.all("p")[0]).to have_content("#{state_1.state}: #{state_1.qty}")
          expect(page.all("p")[1]).to have_content("#{state_2.state}: #{state_2.qty}")
          expect(page.all("p")[2]).to have_content("#{state_3.state}: #{state_3.qty}")
        end

        within("#cities") do
          city_1,city_2,city_3 = @merchant.top_three_cities
          expect(page.all("p")[0]).to have_content("#{city_1.city}: #{city_1.qty}")
          expect(page.all("p")[1]).to have_content("#{city_2.city}: #{city_2.qty}")
          expect(page.all("p")[2]).to have_content("#{city_3.city}: #{city_3.qty}")
        end
      end
    end
    describe 'when I visit an orders show page from my dashboard' do
      scenario 'I can fulfill part of an order' do

        visit merchant_order_path(@o1)

        within("#item-#{@i2.id}") do

          click_on "Fulfill Item"

          expect(current_path).to eq(merchant_order_path(@o1))
          expect(page).to have_content("Item has been fulfilled")
        end

        expect(page).to have_content("Item fulfilled")
      end
    end
    describe 'when all items in an order have been fulfilled by merchants' do
      it 'the order status changes from pending to packaged' do
        visit merchant_order_path(@o1)

          within("#item-#{@i1.id}") do
            click_on "Fulfill Item"
          end
          within("#item-#{@i2.id}") do
            click_on "Fulfill Item"
          end
          within("#item-#{@i3.id}") do
            click_on "Fulfill Item"

          expect(@o1.reload.status).to eq("packaged")
        end
      end
    end
    describe "Merchant stats" do
      it "top user by number orders" do

        merchant = create(:merchant)
        visit logout_path

        visit login_path

        fill_in "Email", with: merchant.email
        fill_in "Password", with: merchant.password

        click_on "Log In"# We forgot to do this line !!!

        user_1 = create(:user, name: "Joe")
        user_2 = create(:user, name: "Melvin")
        user_3 = create(:user, name: "Todd")

          item_1 = create(:item, user: merchant)
          item_2 = create(:item, user: merchant)
          item_3 = create(:item, user: merchant)

          order_1 = create(:order, status: 2, user: user_1)
          order_2 = create(:order, status: 2, user: user_1)
          order_3 = create(:order, status: 2, user: user_1)
          order_4 = create(:order, status: 2, user: user_2)
          order_5 = create(:order, status: 2, user: user_2)
          order_6 = create(:order, status: 2, user: user_3)

            oi_1 = create(:order_item, order: order_1, item: item_1, price: 5, quantity: 7000)
            oi_3 = create(:order_item, order: order_2, item: item_2, price: 3, quantity: 400)
            oi_2 = create(:order_item, order: order_3, item: item_3, price: 2, quantity: 300)

            # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

            visit merchant_dashboard_path

        within("#top-user-order") do
          expect(page).to have_content("Joe")
          expect(page).to have_content(3)
        end
      end
      it "top customer by item count" do

        merchant = create(:merchant)


        user_1 = create(:user, name: "Joe")
        user_2 = create(:user, name: "Melvin")
        user_3 = create(:user, name: "Todd")

          item_1 = create(:item, user: merchant)
          item_2 = create(:item, user: merchant)
          item_3 = create(:item, user: merchant)

          order_1 = create(:order, status: 2, user: user_1)
          order_2 = create(:order, status: 2, user: user_2)
          order_3 = create(:order, status: 2, user: user_3)

            oi_1 = create(:order_item, order: order_1, item: item_1, price: 5, quantity: 7000, fulfilled: true)
            oi_3 = create(:order_item, order: order_2, item: item_2, price: 3, quantity: 400, fulfilled: true)
            oi_2 = create(:order_item, order: order_3, item: item_3, price: 2, quantity: 300, fulfilled: true)

            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

            visit merchant_dashboard_path

        within("#top-user-items") do
          expect(page).to have_content("Joe")
          expect(page).to have_content(7000)
        end
      end
      it "top 3 users by amount spent" do
        merchant = create(:merchant)


        user_1 = create(:user, name: "Joe")
        user_2 = create(:user, name: "Melvin")
        user_3 = create(:user, name: "Todd")

          item_1 = create(:item, user: merchant)
          item_2 = create(:item, user: merchant)
          item_3 = create(:item, user: merchant)

          order_1 = create(:shipped_order, user: user_1)
          order_2 = create(:shipped_order, user: user_2)
          order_3 = create(:shipped_order, user: user_3)

            oi_1 = create(:order_item, order: order_1, item: item_1, price: 5, quantity: 7000)
            oi_3 = create(:order_item, order: order_2, item: item_2, price: 3, quantity: 400)
            oi_2 = create(:order_item, order: order_3, item: item_3, price: 2, quantity: 300)

            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

            visit merchant_dashboard_path

        within("#top-3-users-amount-spent") do
          expect(page.all("p")[0]).to have_content("Joe")
          expect(page.all("p")[1]).to have_content(35000)
          expect(page.all("p")[2]).to have_content("Melvin")
          expect(page.all("p")[3]).to have_content(1200)
          expect(page.all("p")[4]).to have_content("Todd")
          expect(page.all("p")[5]).to have_content(600)
        end
      end
    end
  end
end
