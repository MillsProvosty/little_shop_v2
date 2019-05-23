require 'rails_helper'


RSpec.describe "User log in" do
  describe "Field for email and password, submit valid information" do
    it "as a regular user" do
      user = create(:user, role: "user")

      visit login_path

      fill_in "email",  with: user.email
      fill_in "password", with: user.password
      click_on "Log In"

      expect(current_path).to eq(user_profile_path(user))
      expect(page).to have_content("Welcome back #{user.name}, you are logged in.")
    end

    it "as a merchant user" do
      user = create(:user, role: "merchant")
      visit login_path

      fill_in "email",  with: user.email
      fill_in "password", with: user.password
      click_on "Log In"

      expect(current_path).to eq(merchant_dashboard_path(user))
      expect(page).to have_content("Welcome back #{user.name}, you are logged in.")
    end

    it "as a admin user" do
      user = create(:user, role: "admin")
      visit login_path

      fill_in "email",  with: user.email
      fill_in "password", with: user.password
      click_on "Log In"

      expect(current_path).to eq(items_path)
      expect(page).to have_content("Welcome back #{user.name}, you are logged in.")
    end
  end

  describe "As a registered user, when I visit the login path" do
    it "As a regular user, I am redirected to my profile page" do
      user = create(:user, role: "user")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit login_path

      expect(current_path).to eq(user_profile_path(user))
      expect(page).to have_content("Welcome #{user.name}, you are already logged in.")
    end

    it "As a merchant, I am redirected to my dashboard" do
      user = create(:user, role: "merchant")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit login_path

      expect(current_path).to eq(merchant_dashboard_path(user))
      expect(page).to have_content("Welcome #{user.name}, you are already logged in.")
    end

    it "As an admin, I am redirected to the home page" do
      user = create(:user, role: "admin")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit login_path

      expect(current_path).to eq(items_path)
      expect(page).to have_content("Welcome #{user.name}, you are already logged in.")
    end
  end

  context "When I submit invalid information" do
    before :each do
      @user = create(:user, role: "user")

      visit login_path
    end

    it "redirects me to the login page, and I see a flash message that tells me credentials were incorrect" do
      fill_in "email",  with: "wrong.email"
      fill_in "password", with: @user.password

      click_on "Log In"


      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your credentials were incorrect.")
      expect(page).to_not have_content("Your email was incorrect.")

      fill_in "email",  with: @user.email
      fill_in "password", with: "wrong.password"

      click_on "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Your credentials were incorrect.")
      expect(page).to_not have_content("Your password was incorrect.")
    end
  end
end
