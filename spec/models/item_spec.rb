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
    before :each do
      @item_1 = create(:item)
      @item_2 = create(:item)
      @item_3 = create(:item)
      @item_4 = create(:item)
      @item_5 = create(:item)
      @item_6 = create(:item)
      @item_7 = create(:item)
      @item_8 = create(:item)
      @item_9 = create(:item)
      @item_10 = create(:item)

      @oi_1 = create(:order_item, item: @item_1, quantity: 8, fulfilled: true)
      @oi_2 = create(:order_item, item: @item_2, quantity: 1, fulfilled: true)
      @oi_3 = create(:order_item, item: @item_3, quantity: 4, fulfilled: true)
      @oi_4 = create(:order_item, item: @item_4, quantity: 6, fulfilled: true)
      @oi_5 = create(:order_item, item: @item_5, quantity: 3, fulfilled: true)
      @oi_6 = create(:order_item, item: @item_6, quantity: 5, fulfilled: true)
      @oi_7 = create(:order_item, item: @item_7, quantity: 2, fulfilled: true)
      @oi_8 = create(:order_item, item: @item_8, quantity: 7, fulfilled: true)
      @oi_9 = create(:order_item, item: @item_9, quantity: 10, fulfilled: true)
      @oi_10 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)

    end
    Item.active_items.each do |item|
      create_list(:item, 5)
      create_list(:inactive_item, 5)

      assert item.active
    end
    it ".top_five" do
      expected = [@item_9, @item_10, @item_1, @item_8, @item_4]
      expect(Item.top_five).to eq(expected)
    end
  end
  describe "Instance methods" do
    before :each do
      @item_10 = create(:item)
      @oi_10 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)
      @item_4 = create(:item)
      @oi_4 = create(:order_item, item: @item_4, quantity: 6, fulfilled: true)
    end
    it ".quantity_bought" do

      expect(@item_10.quantity_bought).to eq(9)
      expect(@item_4.quantity_bought).to eq(6)
    end
  end
end
