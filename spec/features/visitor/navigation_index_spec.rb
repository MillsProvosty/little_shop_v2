require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
  before :each do
    visit '/'
  end
 describe 'I see a navigation bar' do

   it 'includes links for welcome page' do
     expect(page).to have_link("Welcome Page")

     click_link "Welcome Page"

     expect(current_path).to eq(root_path)
    end

    it 'includes link to browse all items for sale' do
      expect(page).to have_link("Items for Sale")

      click_link "Items for Sale"

      expect(current_path).to eq(items_path)
    end

    it 'includes link to see all merchants' do
      expect(page).to have_link("Merchants")

      click_link "Merchants"

      expect(current_path).to eq(merchants_path)
    end

    it 'includes link to my shopping cart' do

      expect(page).to have_link("My Cart")

    end

    it 'includes link to log in' do

      expect(page).to have_link("User Log In")

    end

    it 'includes a link to the user regirtration page' do

      expect(page).to have_link("Register as User")

    end
  end
end
