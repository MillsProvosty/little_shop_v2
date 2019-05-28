require 'rails_helper'

RSpec.describe 'Merchant index page' do

  context 'As an unregistered user visiting the merchants index page' do
    before :each do
      @active_merchants = create_list(:merchant, 2)
      @inactive_merchants = create_list(:inactive_merchant, 2)

      visit merchants_path
    end

    scenario 'all active merchants in system are displayed' do
      @active_merchants.each do |merchant|
        within "#merchant-#{merchant.id}" do
          expect(page).to have_content(merchant.name)
          expect(page).to have_content(merchant.state)
          expect(page).to have_content(merchant.city)
          expect(page).to have_content(merchant.date_registered)
        end
      end
    end

    scenario 'no inactive merchants are displayed' do
      @inactive_merchants.each do |merchant|
        expect(page).to_not have_content(merchant.name)
        expect(page).to_not have_content(merchant.state)
        expect(page).to_not have_content(merchant.city)
      end
    end
  end

  describe "As an admin user, when I visit the merchant's index page at '/merchants'" do
    before :each do
      @user = create(:user, role: "admin")
      visit login_path

      fill_in "email",  with: @user.email
      fill_in "password", with: @user.password
      click_on "Log In"
      @merchant_1 = create(:merchant, city: "New Orleans", state: "Louisiana", active: true)
      @merchant_2 = create(:merchant, city: "Seatle", state: "Washington", active: false)
      visit merchants_path
    end
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
      # expect(user.status).to eq("disabled")
      within "#merchant-#{@merchant_1.id}" do
        expect(@merchant_1.active).to eq(true)
        expect(page).to have_link("Disable Merchant")
      end

      within "#merchant-#{@merchant_2.id}" do
          expect(@merchant_2.active).to eq(false)
          expect(page).to have_link("Enable Merchant")
      end
    end
  end
end
