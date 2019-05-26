require 'rails_helper'

RSpec.describe "Users profile from admin, when I visit a users profile page" do
  before :each do
    @user = create(:user)
    @admin = create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end
  it "I see the same information the user would see, except a link to edit their profile" do

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
end
