require 'rails_helper'

RSpec.describe "Admin User Index Page, as an Admin" do
  describe "When I click a new 'Users' link in the nav (only visible to admins), the current route is '/admin/users'" do
    it "Only admin users can reach this path." do

        admin = create(:admin)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit root_path

      within("#admin-links") do
        click_link "Users"
      end
      expect(current_path). to eq(admin_users_path)
    end
    it "Only admin should see this path" do

      user = create(:user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit root_path

      expect(page).to_not have_link("Users")

      visit admin_users_path

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    it "I see all users in the system who are not merchants nor admins." do
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)

      merchant_1 = create(:merchant, created_at: 3.days.ago)
      merchant_2 = create(:merchant, created_at: 3.days.ago)
      merchant_3 = create(:merchant, created_at: 3.days.ago)

      admin_1 = create(:admin, created_at: 3.days.ago)
      admin_2 = create(:admin, created_at: 3.days.ago)
      admin_3 = create(:admin, created_at: 3.days.ago)

      admin = create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_users_path

      within("#user-#{user_1.id}") do
        expect(page).to have_content(user_1.name)
        expect(page).to have_content(user_1.created_at)
        expect(page).to have_button("Upgrade to Merchant")
      end
      within("#user-#{user_2.id}") do
        expect(page).to have_content(user_2.name)
        expect(page).to have_content(user_2.created_at)
        expect(page).to have_button("Upgrade to Merchant")
      end

      within("#user-#{user_3.id}") do
        expect(page).to have_content(user_3.name)
        expect(page).to have_content(user_3.created_at)
        expect(page).to have_button("Upgrade to Merchant")
      end
        expect(page).to_not have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_1.created_at)
        expect(page).to_not have_content(merchant_2.name)
        expect(page).to_not have_content(merchant_2.created_at)
        expect(page).to_not have_content(merchant_3.name)
        expect(page).to_not have_content(merchant_3.created_at)

        expect(page).to_not have_content(admin_1.name)
        expect(page).to_not have_content(admin_1.created_at)
        expect(page).to_not have_content(admin_2.name)
        expect(page).to_not have_content(admin_2.created_at)
        expect(page).to_not have_content(admin_3.name)
        expect(page).to_not have_content(admin_3.created_at)
      end
    end
    it "each users name is a link to a show page for that user, and for each user there is a button called 'Upgrade to Merchant'" do
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)

      merchant_1 = create(:merchant, created_at: 3.days.ago)
      merchant_2 = create(:merchant, created_at: 3.days.ago)
      merchant_3 = create(:merchant, created_at: 3.days.ago)

      admin_1 = create(:admin, created_at: 3.days.ago)
      admin_2 = create(:admin, created_at: 3.days.ago)
      admin_3 = create(:admin, created_at: 3.days.ago)

      admin = create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_users_path

      within("#user-#{user_1.id}") do
        expect(page).to have_link(user_1.name)
        click_link user_1.name
      end
      expect(current_path).to eq(admin_user_path(user_1))
    end
  end
