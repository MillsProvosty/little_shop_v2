require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it {should validate_numericality_of :quantity}
    it {should validate_numericality_of :price}
#    it {should validate_presence_of :fulfilled}
  end

  describe "relationships" do
    it {should belong_to :order}
    it {should belong_to :item}
  end
end
