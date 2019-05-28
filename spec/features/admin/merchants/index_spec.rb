require 'rails_helper'

RSpec.describe "As an admin visiting merchants index" do
  before :each do
    @user = create(:user, role: "admin")
    visit login_path

    fill_in "email",  with: @user.email
    fill_in "password", with: @user.password
    click_on "Log In"
    @merchant_1 = create(:merchant, city: "New Orleans", state: "Louisiana", active: true)
    @merchant_2 = create(:merchant, city: "Seatle", state: "Washington", active: false)
    visit admin_merchants_path
  end

  describe "As an admin user, when I visit the merchant's index page at '/merchants'" do
    it "I see all merchants, and their city and state" do
      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_content("#{@merchant_1.city}")
        expect(page).to have_content("#{@merchant_1.state}")
      end

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_content("#{@merchant_2.city}")
        expect(page).to have_content("#{@merchant_2.state}")
      end
    end

    it "each merchant's name is a link to their dashboard, route admin/merchant/id" do
      within "#merchant-#{@merchant_1.id}" do
        expect(page).to have_link("#{@merchant_1.name}")
      end

      within "#merchant-#{@merchant_2.id}" do
        expect(page).to have_link("#{@merchant_2.name}")
      end
    end

    it "I see a disable button next to merchants not disabled, and enable button next to those disabled" do
      within "#merchant-#{@merchant_1.id}" do
        expect(@merchant_1.active).to eq(true)
        expect(page).to have_button("Disable Merchant")
      end

      within "#merchant-#{@merchant_2.id}" do
          expect(@merchant_2.active).to eq(false)
          expect(page).to have_button("Enable Merchant")
      end
    end
  end

  describe "and I click 'disable' button for enabled merchat, and return to admin's merchant index page" do
    it "returned to admin's merchant index page " do
      visit admin_merchants_path

      click_button "Disable Merchant"

      expect(current_path).to eq(admin_update_merchant_path(@merchant_1.id))

        @merchant_1.reload
    end

    xit "I see a flash message that merchant is disabled" do
      expect(current_pate).to have_content("Merchant #{@merchant_1.name} is now disabled")
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_link("Enable Merchant")
      end
    end

    xit "This merchant cannot log in" do


    end
  end
end
