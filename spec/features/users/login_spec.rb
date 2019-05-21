require 'rails_helper'


RSpec.describe "User log in" do
  before :each do
    @user = create(:user, role: 0)
  end
  describe "Field for email and password, submit valid information" do
    it "as a regular user" do

      visit login_path

      fill_in "email",  with: @user.email
      fill_in "password", with: @user.password
      click_on "Log In"

      expect(current_path).to eq(user_profile_path(@user))
    end
  end
end
