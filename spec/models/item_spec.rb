require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    #it {should validate_inclusion_of :active}
    it {should validate_numericality_of :price}
    it {should validate_presence_of :description}
    it {should validate_presence_of :image}
    it {should validate_numericality_of :inventory}
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:orders).through(:order_items)}
  end

  describe "class methods" do

    Item.active_items.each do |item|
      create_list(:item, 5)
      create_list(:inactive_item, 5)

      assert item.active
    end
  end
end
