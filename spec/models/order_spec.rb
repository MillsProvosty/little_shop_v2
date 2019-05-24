require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    #it {should validate_presence_of :status}
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :order_items}
    it {should have_many(:items).through(:order_items)}
  end

  describe "status" do
    it "can be ceated with a pending status" do
      order = create(:order)
    end
  end

  describe 'instance methods' do
    before :each do
      @user = create(:user)
      @merchant = create(:merchant)
      @i1,@i2,@i3,@i4,@i5,@i6,@i7,@i8,@i9 = create_list(:item, 9, user: @merchant, price: 2)

      @o1,@o2,@o3 = create_list(:order, 3, user: @user)

      create(:order_item, item: @i1, order: @o1)
      create(:order_item, item: @i2, order: @o1)
      create(:order_item, item: @i3, order: @o1)
      create(:order_item, item: @i4, order: @o2)
      create(:order_item, item: @i5, order: @o2)
      create(:order_item, item: @i6, order: @o2)
      create(:order_item, item: @i7, order: @o3)
      create(:order_item, item: @i8, order: @o3)
      create(:order_item, item: @i9, order: @o3)

    end

    it '.item_quantity' do
      expect(@o1.item_quantity).to eq(3)
      expect(@o2.item_quantity).to eq(3)
      expect(@o3.item_quantity).to eq(3)
    end

    it 'items_total_value' do
      expect(@o1.items_total_value.to_f).to eq(6)
      expect(@o2.items_total_value.to_f).to eq(6)
      expect(@o3.items_total_value.to_f).to eq(6)
    end
  end
end
