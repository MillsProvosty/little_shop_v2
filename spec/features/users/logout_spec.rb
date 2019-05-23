require 'rails_helper'

RSpec.describe 'User, Merchant, Admin logout' do

  before :each do
    user = create(:user, role: "admin")
    visit login_path

    fill_in "email",  with: user.email
    fill_in "password", with: user.password
    click_on "Log In"
  end

  describe 'I am redirected home page and see message that I am logged out' do
    it 'deletes items in shopping cart, by deleting session' do
      click_link "Logout"

      expect(page).to have_content("You are now logged out.")
      expect(page).to have_content("Cart: 0")
      expect(current_path).to eq(root_path)
    end
  end
end
