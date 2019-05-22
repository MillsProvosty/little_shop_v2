require 'rails_helper'

RSpec.describe 'As a registered user' do

  before :each do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    visit login_path
  end

  describe 'when I visit my profile page' do
    it 'displays profile data except for password, and an edit link' do

      visit user_profile_path(@user)

      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.address)
      expect(page).to have_content(@user.city)
      expect(page).to have_content(@user.state)
      expect(page).to have_content(@user.zip)
      expect(page).to_not have_content(@user.password)

      expect(page).to have_link("Edit Profile")
    end
  end
end
