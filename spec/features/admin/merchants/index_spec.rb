require 'rails_helper'

RSpec.describe "As an admin visiting merchants index" do
  before :each do
    @admin = create(:admin)
    @user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end
  describe "when I click on a merchants name" do
    it "My URI route should be /admin/merchants/6" do



      visit merchants_path

      click_on @user.name

      expect(current_path).to eq(admin_merchant_path(@user))
      expect(page).to have_content(@merchant.name)
      expect(page).to have_content(@merchant.email)
      expect(page).to have_content(@merchant.address)
      expect(page).to have_content(@merchant.city)
      expect(page).to have_content(@merchant.state)
      expect(page).to have_content(@merchant.zip)
    end
  end
end


# As an admin user
# When I visit the merchant index page ("/merchants")
# And I click on a merchant's name,
# Then my URI route should be ("/admin/merchants/6")
# Then I see everything that merchant would see
