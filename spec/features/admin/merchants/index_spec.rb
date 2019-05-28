require 'rails_helper'

RSpec.describe "As an admin visiting merchants index" do
  before :each do

    admin = create(:admin)
    visit login_path

    fill_in "email",  with: admin.email
    fill_in "password", with: admin.password
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

      expect(current_path).to eq(admin_merchants_path)

        @merchant_1.reload
    end

    it "I see a flash message that merchant is disabled and cannot log in" do
      click_button "Disable Merchant"
      @merchant_1.reload
      expect(current_path).to eq(admin_merchants_path)
      expect(page).to have_content("#{@merchant_1.name} is now disabled")
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_button("Enable Merchant")
      end

      click_on "Logout"
      @merchant_1.reload

      visit login_path
      fill_in "email",  with: @merchant_1.email
      fill_in "password", with: @merchant_1.password
      click_on "Log In"

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe "I click on 'enable' button for a disabled merchant" do
    it "I am returned to admin's merchant page, see flash message merchant account enabled, merchant account is enabled and they can now log in" do
      click_on "Logout"
      visit login_path
      fill_in "email",  with: @user.email
      fill_in "password", with: @user.password
      click_on "Log In"
      visit admin_merchants_path

      click_button "Enable Merchant"

      expect(current_path).to eq(admin_merchants_path)

      expect(page).to have_content("#{@merchant_2.name} is now enabled")
    end
  end
end
