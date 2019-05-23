require 'rails_helper'

RSpec.describe 'As a registered user' do

  before :each do

    @user = create(:user, role: "user")
    visit login_path

    fill_in "email",  with: @user.email
    fill_in "password", with: @user.password
    click_on "Log In"


    visit user_profile_path(@user)
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
      click_on "Edit Profile"

      expect(current_path).to eq(user_edit_path)

        expect(find_field("Name").value).to eq(@user.name)
        expect(find_field("Email").value).to eq(@user.email)
        expect(find_field("Address").value).to eq(@user.address)
        expect(find_field("City").value).to eq(@user.city)
        expect(find_field("State").value).to eq(@user.state)
        expect(find_field("Zip").value).to eq(@user.zip)
        expect(find_field("Password").value).to eq("")
# binding.pry
        find_field("Password").set("Nar")

        find_field("Name").set("Butterfly")
# binding.pryr

        click_button "Submit Edits"
# binding.pry
        expect(current_path).to eq(user_profile_path(@user))

        expect(page).to have_content("Butterfly")

    end
  end
end
