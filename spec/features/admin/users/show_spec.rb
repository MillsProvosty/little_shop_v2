require 'rails_helper'

RSpec.describe "Users profile from admin, when I visit a users profile page" do
  before :each do
    @user = create(:user)
    @admin = create(:admin)
  end
  it "I see the same information the user would see, except a link to edit their profile" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit admin_user_path(@user)

    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.name)
    expect(page).to have_content(@user.address)
    expect(page).to have_content(@user.city)
    expect(page).to have_content(@user.state)
    expect(page).to have_content(@user.zip)
    expect(page).to_not have_content(@user.password)

    expect(page).to_not have_link("Edit Profile")
  end
  it "click a link upgrade user to merchant, redirect to admin_merchant_path(user), see a flash message that user has been upgraded" do

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

    visit admin_user_path(@user)

    click_button "Upgrade to Merchant"

    expect(current_path).to eq(admin_merchant_path(@user))
    expect(page).to have_content("#{@user.name} has been upgraded to Merchant status")
  end
  describe "User role is changed to merchant" do
    it "The next time a user logs in they are now a merchant, only admin can upgrade a user to merchant" do
      visit logout_path
      
      admin = create(:admin)
      user_1 = create(:user)

      visit login_path

      fill_in "email",  with: admin.email
      fill_in "password", with: admin.password
      click_on "Log In"

      visit admin_user_path(user_1)

      click_button "Upgrade to Merchant"

      click_link "Logout"

      visit login_path

      fill_in "email",  with: user_1.email
      fill_in "password", with: user_1.password
      click_on "Log In"

      user_1.reload

      expect(user_1.role).to eq("merchant")
      expect(current_path).to eq(merchant_dashboard_path)
    end
  end
end
