require 'rails_helper'

RSpec.describe "Admin dashboard" do
  describe "When I log in, to admin/dashboard" do
    before :each do
      @user = create(:user)
      @user_2 = create(:user)

      @order_1 = create(:cancelled_order, user: @user)
      @order_2 = create(:packaged_order, user: @user_2)
      @order_3 = create(:shipped_order, user: @user)
      @order_4 = create(:order, user: @user_2)

      @admin = create(:admin)

      visit login_path

      fill_in "email",  with: @admin.email
      fill_in "password", with: @admin.password
      click_on "Log In"


    end
    it "I see all orders in the system, user who placed the order, order id and date created" do

      visit admin_dashboard_path

      within(".all-orders") do

        expect(page).to have_content(@order_1.user.name)
        expect(page).to have_content(@order_1.id)
        expect(page).to have_content(@order_1.created_at)

        expect(page).to have_content(@order_1.user.name)
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.created_at)

        expect(page).to have_content(@order_1.user.name)
        expect(page).to have_content(@order_3.id)
        expect(page).to have_content(@order_3.created_at)

        expect(page).to have_content(@order_1.user.name)
        expect(page).to have_content(@order_4.id)
        expect(page).to have_content(@order_4.created_at)

      end
    end

    it "Orders are sorted by status, packaged, pending, shipped, cancelled" do

      visit admin_dashboard_path
      expect(page.all(".orders")[0]).to have_content(@order_2.user.name)
      expect(page.all(".orders")[0]).to have_content(@order_2.id)
      expect(page.all(".orders")[0]).to have_content(@order_2.created_at)

      expect(page.all(".orders")[1]).to have_content(@order_4.user.name)
      expect(page.all(".orders")[1]).to have_content(@order_4.id)
      expect(page.all(".orders")[1]).to have_content(@order_4.created_at)

      expect(page.all(".orders")[2]).to have_content(@order_3.user.name)
      expect(page.all(".orders")[2]).to have_content(@order_3.id)
      expect(page.all(".orders")[2]).to have_content(@order_3.created_at)

      expect(page.all(".orders")[3]).to have_content(@order_1.user.name)
      expect(page.all(".orders")[3]).to have_content(@order_1.id)
      expect(page.all(".orders")[3]).to have_content(@order_1.created_at)
    end
    it "I see any packaged orders ready to ship" do
      visit admin_dashboard_path

      within("#order-#{@order_2.id}") do
        expect(page).to have_content(@order_2.id)
        expect(page).to have_content(@order_2.status)
        expect(page).to have_button("Ship")

        click_on "Ship"

        @order_2.reload
        expect(@order_2.status).to eq("shipped")
        expect(page).to have_content(@order_2.status)
      end

        visit logout_path
        visit login_path
        fill_in "email",  with: @user_2.email
        fill_in "password", with: @user_2.password
        click_on "Log In"

        visit user_orders_path

      within("#order-#{@order_2.id}") do
        expect(page).to_not have_button("Ship")
      end
    end
  end
end
