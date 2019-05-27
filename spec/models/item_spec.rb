require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
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
      @oi_13 = create(:order_item, item: @item_8, quantity: 7, fulfilled: true)
      @oi_9 = create(:order_item, item: @item_9, quantity: 10, fulfilled: true)
      @oi_10 = create(:order_item, item: @item_9, quantity: 5, fulfilled: true)
      @oi_11 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)
      @oi_12 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)

      @oi_n1 = create(:order_item, item: @item_1, quantity: 11, fulfilled: false)
      @oi_n2 = create(:order_item, item: @item_2, quantity: 1, fulfilled: false)
      @oi_n3 = create(:order_item, item: @item_3, quantity: 2, fulfilled: false)
      @oi_n4 = create(:order_item, item: @item_4, quantity: 1, fulfilled: false)
      @oi_n5 = create(:order_item, item: @item_5, quantity: 4, fulfilled: false)
      @oi_n6 = create(:order_item, item: @item_6, quantity: 6, fulfilled: false)
      @oi_n7 = create(:order_item, item: @item_7, quantity: 11, fulfilled: false)
      @oi_n8 = create(:order_item, item: @item_8, quantity: 12, fulfilled: false)
      @oi_n9 = create(:order_item, item: @item_9, quantity: 3, fulfilled: false)
      @oi_n10 = create(:order_item, item: @item_10, quantity: 8, fulfilled: false)
    end

    it ".active_items" do
      Item.active_items.each do |item|
        create_list(:item, 5)
        create_list(:inactive_item, 5)

        assert item.active
      end
    end

    it ".top_five" do
      expected = [@item_10, @item_9, @item_8, @item_1, @item_4]
      expect(Item.top_five).to eq(expected)
    end

    it ".bottom_five" do
      expected = [@item_2, @item_7, @item_5, @item_3, @item_6]
      expect(Item.bottom_five).to eq(expected)
    end
  end

  describe "Instance methods" do
    before :each do
      @item_10 = create(:item)
      @oi_10 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)
      @oi_11 = create(:order_item, item: @item_10, quantity: 9, fulfilled: true)
      @item_4 = create(:item)
      @oi_4 = create(:order_item, item: @item_4, quantity: 6, fulfilled: true)
    end

    it ".quantity_bought" do

      expect(@item_10.quantity_bought).to eq(18)
      expect(@item_4.quantity_bought).to eq(6)
    end

    it ".avg_fulfill_time" do
      merchant = create(:merchant)
      item = create(:item, user: merchant)
      io_1 = create(:order_item, item: item, created_at: 3.days.ago)
      io_1.fulfilled = true
      io_2 = create(:order_item, item: item, created_at: 5.days.ago)
      io_2.fulfilled = true
      io_3 = create(:order_item, item: item, created_at: 7.days.ago)
      io_3.fulfilled = true

      expect(item.avg_fulfill_time).to eq(120)
    end


    it '#quantity_on_order' do
      item = create(:item)
      order_1, order_2 = create_list(:order, 2)
      order_item_1 = create(:order_item, item: item, order: order_1, quantity: 3)
      order_item_2 = create(:order_item, item: item, order: order_2, quantity: 1)

      expect(item.quantity_on_order(order_1)).to eq(order_item_1.quantity)
      expect(item.quantity_on_order(order_2)).to eq(order_item_2.quantity)
    end

    it ".item_subtotal" do
      user = create(:user)

      order_1 = create(:order, user: user)
        item_1 = create(:item, price: 2)
        item_2 = create(:item, price: 3)
        item_3 = create(:item, price: 4)
          o1_oi1 = create(:order_item, order: order_1, item: item_1, quantity: 1)
          o1_oi2 = create(:order_item, order: order_1, item: item_2, quantity: 2)
          o1_oi3 = create(:order_item, order: order_1, item: item_3, quantity: 3)
          o1_oi4 = create(:order_item, order: order_1, item: item_3, quantity: 4)
          o1_oi5 = create(:order_item, order: order_1, item: item_3, quantity: 5)

      expect(item_3.item_subtotal.to_f).to eq(48.0)
    end
  end
end
