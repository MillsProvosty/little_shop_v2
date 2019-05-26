require 'rails_helper'

RSpec.describe 'Mechant index page' do

  context 'As an unregistered user visiting the merchants index page' do
    before :each do
      active_merchants = create_list(:merchants, 2)
      inactive_merchant = create(:inactive_merchant)

      visit merchants_path
    end

    scenario 'all active merchants in system are displayed' do
      active_merchants.each do |merchant|
        within "merchant-#{merchant.id}" do
          expect(page).to have_content(merchant.name)
          expect(page).to have_content(merchant.state)
          expect(page).to have_content(merchant.city)
          expect(page).to have_content(merchant.created_at)
        end
      end
    end
  end
end
