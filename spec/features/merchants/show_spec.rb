require 'rails_helper'

RSpec.describe 'Merchant Show page' do

  describe 'when I visit my dashboard' do

    it 'i see my profile data but cannot edit it' do

      visit login_path

      merchant = create(:merchant)

      fill_in "email", with: merchant.email
      fill_in "password", with: merchant.password

      click_on "Log In"

      expect(current_path).to eq(merchant_dashboard_path)

      expect(page).to have_content(merchant.name)
      expect(page).to have_content(merchant.email)
      expect(page).to have_content(merchant.address)
      expect(page).to have_content(merchant.city)
      expect(page).to have_content(merchant.state)
      expect(page).to have_content(merchant.zip)

      expect(page).to_not have_link("Edit Profile")
    end
  end

end
