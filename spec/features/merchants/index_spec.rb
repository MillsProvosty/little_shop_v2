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
end
