require 'rails_helper'

RSpec.describe "As a visitor on the index page" do
  describe "when I click on the register link in the nav bar" do
    describe "I see a form with the following data" do
      before :each do
        visit root_path
      end

      it "I enter name, address, city, state, zip, email, password and confirmation field for password, saves my info into db and logs me in as a user" do
        expect(page).to have_link("Register as User")

        click_link "Register as User"

        expect(current_path).to eq(new_user_path)

        fill_in "Name", with: "Bob Dylan"
        fill_in "Email", with: "TheBob@email.com"
        fill_in "Address", with: "123 Highway 51"
        fill_in "City", with: "Tombstone"
        fill_in "State", with: "Arizona"
        fill_in "Zip", with: "84029"
        fill_in "Password", with: "pass123"
        fill_in "Password confirmation", with: "pass123"
        click_on "Create User"

        new_user = User.last

        expect(current_path).to eq(user_profile_path(new_user))
        expect(page).to have_content("Congratulations #{new_user.name}! You are now registered and logged in.")
      end

    end
  end
end
