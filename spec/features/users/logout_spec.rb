require 'rails_helper'

RSpec.describe 'User, Merchant, Admin logout' do

  before :each do
    user = create(:user, role: "admin")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit user_profile_path(user)
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
