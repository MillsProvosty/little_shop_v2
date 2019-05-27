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

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

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

      expect(page.all("p")[0]).to have_content(@order_4.user.name)
      expect(page.all("p")[1]).to have_content(@order_4.id)
      expect(page.all("p")[2]).to have_content(@order_4.created_at)

      expect(page.all("p")[3]).to have_content(@order_2.user.name)
      expect(page.all("p")[4]).to have_content(@order_2.id)
      expect(page.all("p")[5]).to have_content(@order_2.created_at)

      expect(page.all("p")[6]).to have_content(@order_3.user.name)
      expect(page.all("p")[7]).to have_content(@order_3.id)
      expect(page.all("p")[8]).to have_content(@order_3.created_at)

      expect(page.all("p")[9]).to have_content(@order_1.user.name)
      expect(page.all("p")[10]).to have_content(@order_1.id)
      expect(page.all("p")[11]).to have_content(@order_1.created_at)
    end
  end
end
