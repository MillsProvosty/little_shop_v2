require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it {should validate_numericality_of :status}
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
  end
end
