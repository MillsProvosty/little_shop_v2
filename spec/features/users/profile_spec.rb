require 'rails_helper'

RSpec.describe 'As a registered user' do

  before :each do

    @user = create(:user, role: "user")
    visit login_path

    fill_in "email",  with: @user.email
    fill_in "password", with: @user.password
    click_on "Log In"


    visit user_profile_path
  end

  describe 'when I visit my profile page' do
    it 'displays profile data except for password, and an edit link' do

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

  describe 'when I click on the edit profile link' do
    it 'I see a form like the registration page that contains my info without password,' do
      click_link "Edit Profile"

      expect(current_path).to eq(user_edit_path)

        expect(find_field("Name").value).to eq(@user.name)
        expect(find_field("Email").value).to eq(@user.email)
        expect(find_field("Address").value).to eq(@user.address)
        expect(find_field("City").value).to eq(@user.city)
        expect(find_field("State").value).to eq(@user.state)
        expect(find_field("Zip").value).to eq(@user.zip)
        expect(find_field("Password").value).to eq("")

        find_field("Password").set("Nar")

        find_field("Name").set("Butterfly")


        click_button "Submit Edits"

        expect(current_path).to eq(user_profile_path)

        expect(page).to have_content("Butterfly")
    end

    it "cannot edit profile with an email already in use" do
      user = create(:user, email: "k_log@gmail.com")
      user_1 = create(:user)

      click_link "Logout"

      visit login_path


      fill_in "email",  with: user_1.email
      fill_in "password", with: user_1.password
      click_on "Log In"

      expect(current_path).to eq(user_profile_path)

      click_link "Edit Profile"

      expect(current_path).to eq(user_edit_path)

      find_field("Email").set(user.email)

      click_button "Submit Edits"

      expect(current_path).to eq(user_update_path)
      expect(page).to have_content("This email is already in use")
    end
    describe "User orders page from profile" do
      before :each do
        @user = create(:user)

        @order_1 = create(:order, user: @user)
        @order_2 = create(:packaged_order, user: @user)
        @order_3 = create(:shipped_order, user: @user)
        @order_4 = create(:cancelled_order, user: @user)

      end
      it "from profile I see a link called 'My Orders', click it and and my uri path is /profile/orders" do

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit user_profile_path

      within(".user-links") do
        click_link "My Orders"
      end
      expect(current_path).to eq(profile_orders_path)
      end
    end
  end
end
