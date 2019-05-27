require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
  end

  describe "status" do
    it "can be ceated with a pending status" do
      order = create(:order)
      expect(order.status).to eq("pending")
    end
  end

  describe 'instance methods' do
    before :each do
      @user = create(:user)
      @merchant = create(:merchant)
      @i1,@i2,@i3,@i4,@i5,@i6,@i7,@i8,@i9 = create_list(:item, 9, user: @merchant, price: 2.0)

      @o1,@o2,@o3 = create_list(:order, 3, user: @user)

      create(:order_item, item: @i1, order: @o1, quantity: 3)
      create(:order_item, item: @i2, order: @o1, quantity: 7)
      create(:order_item, item: @i3, order: @o1, quantity: 10)
      create(:order_item, item: @i4, order: @o2, quantity: 4)
      create(:order_item, item: @i5, order: @o2, quantity: 10)
      create(:order_item, item: @i6, order: @o2, quantity: 7)
      create(:order_item, item: @i7, order: @o3, quantity: 5)
      create(:order_item, item: @i8, order: @o3, quantity: 10)
      create(:order_item, item: @i9, order: @o3, quantity: 7)
    end

    it '.item_quantity' do
      expect(@o1.item_quantity).to eq(20)
      expect(@o2.item_quantity).to eq(21)
      expect(@o3.item_quantity).to eq(22)
    end

    it '#items_total_value' do
      expect(@o1.items_total_value.to_f).to eq(316.0)
      expect(@o2.items_total_value.to_f).to eq(330.0)
      expect(@o3.items_total_value.to_f).to eq(348.0)
    end

    it '#find_items_for_merchant_on_order' do
      merchant = create(:merchant)

      i1,i2 = create_list(:item, 2, user: merchant)
      order = create(:order)
      order_item = create(:order_item, order: order, item: i1)

      expect(order.items_from_merchant(merchant.id)).to eq([i1])
    end

    it '#item_count_for_merchant' do
      merchant = create(:merchant)

      i1,i2 = create_list(:item, 2, user: merchant)
      order = create(:order)
      order_item = create(:order_item, order: order, item: i1, quantity: 4)

      expect(order.item_count_for_merchant(merchant.id)).to eq (4)
    end
    it '#item_total_value_for_merchant' do
      merchant = create(:merchant)

      i1,i2 = create_list(:item, 2, user: merchant, price: 2.0)
      order = create(:order)
      order_item = create(:order_item, order: order, item: i1, price: 2.0, quantity: 4)

      expect(order.item_total_value_for_merchant(merchant.id).to_f).to eq(8.0)

    end
  end
end
