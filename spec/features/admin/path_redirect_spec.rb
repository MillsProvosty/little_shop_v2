require 'rails_helper'

RSpec.describe "As an admin user" do
  before :each do
    @admin = create(:admin)
      @merchant = create(:merchant)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
  end
  describe "If i visit a user profile page, but that user is a merchant" do
    it "I am redirected to the appropriate merchant dashboard page" do

      visit admin_user_path(@merchant)

      expect(current_path).to eq(admin_merchant_path(@merchant))
    end
  end
end
